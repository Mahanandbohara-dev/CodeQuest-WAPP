using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using CodeQuest.Models;

namespace CodeQuest.Controllers;

public class AiController : Controller
{
    // =========================================================================
    // ANTHROPIC CLAUDE API KEY PLACEHOLDER
    // Paste your Claude API key directly into the string below, OR set
    // "Anthropic:ApiKey" in appsettings.json.
    // Example: "sk-ant-api03-abcdef123456..."
    // =========================================================================
    public const string ClaudeApiKeyPlaceholder = "PASTE_YOUR_CLAUDE_API_KEY_HERE";

    private readonly IConfiguration _config;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<AiController> _logger;

    public AiController(IConfiguration config, IHttpClientFactory httpClientFactory, ILogger<AiController> logger)
    {
        _config = config;
        _httpClientFactory = httpClientFactory;
        _logger = logger;
    }

    [HttpGet]
    public IActionResult Chat()
    {
        if (HttpContext.Session.GetInt32("UserId") == null)
            return RedirectToAction("Login", "Account", new { returnUrl = "/Ai/Chat" });

        ViewBag.Username = HttpContext.Session.GetString("Username") ?? "Learner";
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Chat([FromBody] AiChatRequest request)
    {
        if (HttpContext.Session.GetInt32("UserId") == null)
            return Unauthorized();

        if (string.IsNullOrWhiteSpace(request.Message))
            return BadRequest(new { error = "Message cannot be empty." });

        var apiKey = !string.IsNullOrWhiteSpace(ClaudeApiKeyPlaceholder) &&
                     ClaudeApiKeyPlaceholder != "PASTE_YOUR_CLAUDE_API_KEY_HERE"
            ? ClaudeApiKeyPlaceholder
            : _config["Anthropic:ApiKey"];

        if (!string.IsNullOrWhiteSpace(apiKey) && apiKey != "PASTE_YOUR_CLAUDE_API_KEY_HERE")
        {
            try
            {
                var reply = await CallClaudeChatAsync(apiKey, request);
                if (!string.IsNullOrWhiteSpace(reply))
                {
                    return Json(new { reply });
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Claude Chat API call failed. Using offline mentor fallback.");
            }
        }

        // Offline mentor fallback
        return Json(new { reply = GenerateOfflineMentorReply(request.Message) });
    }

    private async Task<string?> CallClaudeChatAsync(string apiKey, AiChatRequest request)
    {
        var client = _httpClientFactory.CreateClient();
        client.Timeout = TimeSpan.FromSeconds(25);

        using var httpRequest = new HttpRequestMessage(HttpMethod.Post, "https://api.anthropic.com/v1/messages");
        httpRequest.Headers.Add("x-api-key", apiKey);
        httpRequest.Headers.Add("anthropic-version", "2023-06-01");

        var model = _config["Anthropic:Model"] ?? "claude-3-5-sonnet-20241022";
        
        var messagesList = new List<object>();

        // Include recent history (up to last 6 messages)
        if (request.History != null && request.History.Count > 0)
        {
            var recentHistory = request.History.TakeLast(6);
            foreach (var h in recentHistory)
            {
                var role = h.Role.ToLowerInvariant() == "assistant" ? "assistant" : "user";
                if (!string.IsNullOrWhiteSpace(h.Content))
                {
                    messagesList.Add(new { role = role, content = h.Content });
                }
            }
        }

        messagesList.Add(new { role = "user", content = request.Message });

        var payload = new
        {
            model = model,
            max_tokens = 600,
            system = "You are CodeQuest AI, a knowledgeable, patient, and pedagogical coding mentor. Explain concepts with clear code examples where appropriate. Keep answers structured, encouraging, and focused.",
            messages = messagesList
        };

        httpRequest.Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        using var response = await client.SendAsync(httpRequest);
        if (!response.IsSuccessStatusCode)
        {
            var err = await response.Content.ReadAsStringAsync();
            _logger.LogWarning("Claude Chat API returned {StatusCode}: {Error}", response.StatusCode, err);
            return null;
        }

        var responseBody = await response.Content.ReadAsStringAsync();
        using var doc = JsonDocument.Parse(responseBody);
        if (doc.RootElement.TryGetProperty("content", out var contentArray) && contentArray.GetArrayLength() > 0)
        {
            return contentArray[0].GetProperty("text").GetString();
        }

        return null;
    }

    [HttpPost]
    public async Task<IActionResult> Ask([FromBody] AskAiRequest request)
    {
        if (HttpContext.Session.GetInt32("UserId") == null)
            return Unauthorized();

        // 1. Resolve API key from either the code constant or appsettings.json
        var apiKey = !string.IsNullOrWhiteSpace(ClaudeApiKeyPlaceholder) &&
                     ClaudeApiKeyPlaceholder != "PASTE_YOUR_CLAUDE_API_KEY_HERE"
            ? ClaudeApiKeyPlaceholder
            : _config["Anthropic:ApiKey"];

        // 2. If no valid key is set, use the offline intelligent tutor hint generator
        if (string.IsNullOrWhiteSpace(apiKey) || apiKey == "PASTE_YOUR_CLAUDE_API_KEY_HERE")
        {
            _logger.LogInformation("Claude API key not configured. Using intelligent rule-based hint generator.");
            return Json(new { answer = BuildOfflineHint(request.Topic, request.Question) });
        }

        // 3. Call Anthropic Claude API
        try
        {
            var hint = await CallClaudeApiAsync(apiKey, request.Topic, request.Question);
            if (!string.IsNullOrWhiteSpace(hint))
            {
                return Json(new { answer = hint });
            }
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Failed to call Claude API. Falling back to offline hint generator.");
        }

        // Graceful fallback if API call fails or quota runs out
        return Json(new { answer = BuildOfflineHint(request.Topic, request.Question) });
    }

    private async Task<string?> CallClaudeApiAsync(string apiKey, string topic, string question)
    {
        var client = _httpClientFactory.CreateClient();
        client.Timeout = TimeSpan.FromSeconds(15);

        using var request = new HttpRequestMessage(HttpMethod.Post, "https://api.anthropic.com/v1/messages");
        request.Headers.Add("x-api-key", apiKey);
        request.Headers.Add("anthropic-version", "2023-06-01");

        var model = _config["Anthropic:Model"] ?? "claude-3-5-sonnet-20241022";
        var prompt = $"You are CodeQuest AI, an encouraging and insightful programming tutor. " +
                     $"The learner is working on a {topic} quiz question:\n\"{question}\"\n\n" +
                     $"Provide a concise, helpful hint (2 to 3 sentences maximum) to help them reason through the question " +
                     $"without giving away the direct multiple-choice answer letter.";

        var payload = new
        {
            model = model,
            max_tokens = 300,
            messages = new[]
            {
                new { role = "user", content = prompt }
            }
        };

        request.Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        using var response = await client.SendAsync(request);
        if (!response.IsSuccessStatusCode)
        {
            var err = await response.Content.ReadAsStringAsync();
            _logger.LogWarning("Claude API returned status {StatusCode}: {Error}", response.StatusCode, err);
            return null;
        }

        var responseBody = await response.Content.ReadAsStringAsync();
        using var doc = JsonDocument.Parse(responseBody);

        if (doc.RootElement.TryGetProperty("content", out var contentArray) && contentArray.GetArrayLength() > 0)
        {
            var text = contentArray[0].GetProperty("text").GetString();
            return text;
        }

        return null;
    }

    private static string BuildOfflineHint(string topic, string question)
    {
        var text = $"{topic} {question}";

        if (text.Contains("loop", StringComparison.OrdinalIgnoreCase))
            return "Hint: identify the loop's starting value, stopping condition, and update step. Trace one or two iterations by hand.";

        if (text.Contains("class", StringComparison.OrdinalIgnoreCase) ||
            text.Contains("object", StringComparison.OrdinalIgnoreCase))
            return "Hint: separate the type's data from its behavior, then check which member should own the operation.";

        if (text.Contains("array", StringComparison.OrdinalIgnoreCase) ||
            text.Contains("list", StringComparison.OrdinalIgnoreCase))
            return "Hint: check the collection's zero-based index and whether the code is changing the collection while iterating over it.";

        if (text.Contains("sql", StringComparison.OrdinalIgnoreCase) ||
            text.Contains("database", StringComparison.OrdinalIgnoreCase))
            return "Hint: identify the rows the query should return first, then verify each filter and join condition independently.";

        if (text.Contains("async", StringComparison.OrdinalIgnoreCase) ||
            text.Contains("await", StringComparison.OrdinalIgnoreCase))
            return "Hint: follow the task from its creation to await, and make sure the result is awaited instead of inspected before completion.";

        return $"Hint: break the {topic} question into its inputs, the operation being performed, and the expected result. Eliminate options that conflict with those steps.";
    }

    private static string GenerateOfflineMentorReply(string query)
    {
        var q = query.ToLowerInvariant();

        if (q.Contains("loop") || q.Contains("for") || q.Contains("while"))
        {
            return "Loops repeat a block of code until a specified condition is met.\n\n" +
                   "• **for loop**: Best when you know the number of iterations in advance.\n" +
                   "• **while loop**: Best when looping until an external condition changes.\n\n" +
                   "```python\n# Example: Python for loop\nfor i in range(1, 6):\n    print(f\"Iteration {i}\")\n```\n\n" +
                   "*Tip: In while loops, always verify that your loop counter advances so you avoid infinite loops!*";
        }

        if (q.Contains("recursion") || q.Contains("recursive"))
        {
            return "Recursion is a programming technique where a function calls itself to solve smaller instances of the same problem.\n\n" +
                   "Every valid recursive function requires:\n" +
                   "1. **Base Case**: The condition that stops recursion.\n" +
                   "2. **Recursive Step**: The call to itself with updated parameters moving toward the base case.\n\n" +
                   "```python\ndef factorial(n):\n    if n <= 1:  # Base case\n        return 1\n    return n * factorial(n - 1)  # Recursive step\n```";
        }

        if (q.Contains("async") || q.Contains("await") || q.Contains("promise"))
        {
            return "Asynchronous programming lets your program perform long operations (like database queries or HTTP calls) without freezing the main execution thread.\n\n" +
                   "• In JavaScript, **Promises** represent eventual values, and `async`/`await` provides clean syntax.\n" +
                   "• In C#, **Tasks** represent asynchronous operations.\n\n" +
                   "```javascript\nasync function fetchUserData(userId) {\n    try {\n        const response = await fetch(`/api/users/${userId}`);\n        return await response.json();\n    } catch (err) {\n        console.error('Fetch failed', err);\n    }\n}\n```";
        }

        if (q.Contains("array") || q.Contains("list") || q.Contains("vector"))
        {
            return "Arrays and Lists store ordered collections of elements.\n\n" +
                   "• **Index access**: Fast O(1) random lookup by index (e.g. `list[0]`).\n" +
                   "• **Dynamic resizing**: Lists expand automatically as items are appended.\n\n" +
                   "```csharp\n// C# Example\nvar languages = new List<string> { \"Python\", \"C#\", \"JavaScript\" };\nlanguages.Add(\"Java\");\nConsole.WriteLine($\"Total languages: {languages.Count}\");\n```";
        }

        if (q.Contains("class") || q.Contains("object") || q.Contains("oop"))
        {
            return "Object-Oriented Programming (OOP) structures code into reusable blueprints called classes that combine data (fields/properties) and actions (methods).\n\n" +
                   "**The 4 Core Pillars of OOP**:\n" +
                   "1. **Encapsulation**: Bundling data with methods and guarding direct access.\n" +
                   "2. **Inheritance**: Subclasses inherit fields and behaviors from base classes.\n" +
                   "3. **Polymorphism**: Overriding methods to customize behavior dynamically.\n" +
                   "4. **Abstraction**: Exposing simple interfaces while hiding internal complexities.";
        }

        if (q.Contains("sql") || q.Contains("database") || q.Contains("select"))
        {
            return "SQL (Structured Query Language) manages relational databases.\n\n" +
                   "```sql\n-- Retrieve top scoring learners\nSELECT TOP (5) Username, TotalScore, CurrentStreak\nFROM dbo.Users\nWHERE Role = 'Learner'\nORDER BY TotalScore DESC;\n```\n\n" +
                   "*Security Tip: In ASP.NET Core, always use parameterized SQL queries (`SqlCommand.Parameters`) to prevent SQL injection vulnerabilities!*";
        }

        return $"Great question about \"{query.Trim()}\"! As your CodeQuest AI mentor, I recommend breaking it down step-by-step:\n\n" +
               "1. **Identify the core concept** (syntax, algorithm, data structure, or logic).\n" +
               "2. **Trace a minimal code snippet** with test inputs and expected outputs.\n" +
               "3. **Take a 5-question quiz** in our Topics tab to test your mastery!\n\n" +
               "*Ask me to explain any topic, debug code, or give examples in Python, JavaScript, Java, C++, HTML, CSS, or SQL!*";
    }
}
