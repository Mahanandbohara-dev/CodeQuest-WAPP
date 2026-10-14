using System.Security.Cryptography;
using CodeQuest.Data;
using CodeQuest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace CodeQuest.Controllers;

public class AdminController : Controller
{
    private readonly IConfiguration _config;
    private readonly ILogger<AdminController> _logger;

    public AdminController(IConfiguration config, ILogger<AdminController> logger)
    {
        _config = config;
        _logger = logger;
    }

    private bool IsAdmin() => HttpContext.Session.GetString("Role") == "Administrator";

    public async Task<IActionResult> Index()
    {
        if (!IsAdmin())
        {
            TempData["Error"] = "Administrator access required.";
            return RedirectToAction("Login", "Account");
        }

        var vm = new AdminDashboardViewModel();

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            // 1. Stats
            await using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users", con))
                vm.TotalUsers = Convert.ToInt32(await cmd.ExecuteScalarAsync());

            await using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Questions", con))
                vm.TotalQuestions = Convert.ToInt32(await cmd.ExecuteScalarAsync());

            await using (var cmd = new SqlCommand("SELECT COUNT(*) FROM QuizAttempts", con))
                vm.TotalAttempts = Convert.ToInt32(await cmd.ExecuteScalarAsync());

            await using (var cmd = new SqlCommand("SELECT ISNULL(AVG(CAST(Score AS FLOAT)), 0) FROM QuizAttempts", con))
                vm.AverageScore = Math.Round(Convert.ToDouble(await cmd.ExecuteScalarAsync()), 1);

            // 2. Users
            await using (var cmd = new SqlCommand("""
                SELECT Id, Username, Email, ISNULL(Address, '') AS Address, ISNULL(Country, '') AS Country, 
                       Role, TotalScore, CurrentStreak, CreatedAt
                FROM Users
                ORDER BY CreatedAt DESC
                """, con))
            {
                await using var r = await cmd.ExecuteReaderAsync();
                while (await r.ReadAsync())
                {
                    vm.Users.Add(new AdminUserViewModel
                    {
                        Id = r.GetInt32(0),
                        Username = r.GetString(1),
                        Email = r.GetString(2),
                        Address = r.GetString(3),
                        Country = r.GetString(4),
                        Role = r.GetString(5),
                        TotalScore = r.GetInt32(6),
                        CurrentStreak = r.GetInt32(7),
                        CreatedAt = r.GetDateTime(8)
                    });
                }
            }

            // 3. Questions
            await using (var cmd = new SqlCommand("""
                SELECT Id, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, ISNULL(Explanation, '')
                FROM Questions
                ORDER BY Language ASC, Id DESC
                """, con))
            {
                await using var r = await cmd.ExecuteReaderAsync();
                while (await r.ReadAsync())
                {
                    vm.Questions.Add(new AdminQuestionViewModel
                    {
                        Id = r.GetInt32(0),
                        Language = r.GetString(1),
                        Difficulty = r.GetString(2),
                        QuestionText = r.GetString(3),
                        OptionA = r.GetString(4),
                        OptionB = r.GetString(5),
                        OptionC = r.GetString(6),
                        OptionD = r.GetString(7),
                        CorrectOption = r.GetString(8),
                        Explanation = r.GetString(9)
                    });
                }
            }

            // 4. Recent Attempts
            await using (var cmd = new SqlCommand("""
                SELECT TOP (10) qa.Id, ISNULL(q.Language, 'Quiz') AS Language, qa.Score, qa.TotalQuestions, qa.AttemptedAt
                FROM QuizAttempts qa
                LEFT JOIN AttemptDetails ad ON ad.AttemptId = qa.Id
                LEFT JOIN Questions q ON q.Id = ad.QuestionId
                GROUP BY qa.Id, q.Language, qa.Score, qa.TotalQuestions, qa.AttemptedAt
                ORDER BY qa.AttemptedAt DESC
                """, con))
            {
                await using var r = await cmd.ExecuteReaderAsync();
                while (await r.ReadAsync())
                {
                    vm.RecentAttempts.Add(new QuizAttemptItem
                    {
                        Id = r.GetInt32(0),
                        Language = r.GetString(1),
                        Score = r.GetInt32(2),
                        TotalQuestions = r.GetInt32(3),
                        AttemptedAt = r.GetDateTime(4)
                    });
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error loading admin dashboard");
            ViewBag.Error = "Database error while loading management console.";
        }

        return View(vm);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> AddQuestion(AdminQuestionViewModel model)
    {
        if (!IsAdmin()) return Unauthorized();

        if (string.IsNullOrWhiteSpace(model.QuestionText) ||
            string.IsNullOrWhiteSpace(model.OptionA) ||
            string.IsNullOrWhiteSpace(model.OptionB) ||
            string.IsNullOrWhiteSpace(model.CorrectOption))
        {
            TempData["Error"] = "Please fill in all question fields.";
            return RedirectToAction("Index");
        }

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            var sql = """
                INSERT INTO Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
                SELECT Id, @lang, @diff, @qt, @oa, @ob, @oc, @od, @co, @exp
                FROM Categories WHERE Name = @lang;
                """;

            await using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@lang", model.Language);
            cmd.Parameters.AddWithValue("@diff", model.Difficulty ?? "Beginner");
            cmd.Parameters.AddWithValue("@qt", model.QuestionText.Trim());
            cmd.Parameters.AddWithValue("@oa", model.OptionA.Trim());
            cmd.Parameters.AddWithValue("@ob", model.OptionB.Trim());
            cmd.Parameters.AddWithValue("@oc", model.OptionC?.Trim() ?? "");
            cmd.Parameters.AddWithValue("@od", model.OptionD?.Trim() ?? "");
            cmd.Parameters.AddWithValue("@co", model.CorrectOption.Trim().ToUpper());
            cmd.Parameters.AddWithValue("@exp", (object?)model.Explanation?.Trim() ?? DBNull.Value);

            int affected = await cmd.ExecuteNonQueryAsync();
            if (affected > 0)
            {
                TempData["Success"] = $"Question for {model.Language} added successfully!";
            }
            else
            {
                TempData["Error"] = $"Could not add question. Make sure category '{model.Language}' exists.";
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating question");
            TempData["Error"] = "Failed to add question due to database error.";
        }

        return RedirectToAction("Index");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteQuestion(int id)
    {
        if (!IsAdmin()) return Unauthorized();

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));
            await using var cmd = new SqlCommand("DELETE FROM Questions WHERE Id=@id", con);
            cmd.Parameters.AddWithValue("@id", id);
            await cmd.ExecuteNonQueryAsync();
            TempData["Success"] = "Question deleted successfully.";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting question");
            TempData["Error"] = "Failed to delete question.";
        }

        return RedirectToAction("Index");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> ToggleUserRole(int id)
    {
        if (!IsAdmin()) return Unauthorized();

        int? currentUserId = HttpContext.Session.GetInt32("UserId");
        if (currentUserId == id)
        {
            TempData["Error"] = "You cannot change your own role.";
            return RedirectToAction("Index");
        }

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));
            var sql = """
                UPDATE Users
                SET Role = CASE WHEN Role = 'Administrator' THEN 'Learner' ELSE 'Administrator' END
                WHERE Id = @id;
                """;
            await using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@id", id);
            await cmd.ExecuteNonQueryAsync();
            TempData["Success"] = "User role updated successfully.";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error changing user role");
            TempData["Error"] = "Failed to update user role.";
        }

        return RedirectToAction("Index");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteUser(int id)
    {
        if (!IsAdmin()) return Unauthorized();

        int? currentUserId = HttpContext.Session.GetInt32("UserId");
        if (currentUserId == id)
        {
            TempData["Error"] = "You cannot delete your own logged-in account.";
            return RedirectToAction("Index");
        }

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));
            await using var cmd = new SqlCommand("DELETE FROM Users WHERE Id=@id", con);
            cmd.Parameters.AddWithValue("@id", id);
            await cmd.ExecuteNonQueryAsync();
            TempData["Success"] = "User deleted successfully.";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting user");
            TempData["Error"] = "Failed to delete user.";
        }

        return RedirectToAction("Index");
    }
}
