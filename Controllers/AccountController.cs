using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;
using System.Text;
using CodeQuest.Data;
using CodeQuest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace CodeQuest.Controllers;

public class AccountController : Controller
{
    private readonly IConfiguration _config;
    private readonly ILogger<AccountController> _logger;

    public AccountController(IConfiguration config, ILogger<AccountController> logger)
    {
        _config = config;
        _logger = logger;
    }

    [HttpGet]
    public IActionResult Login(string? returnUrl = null)
    {
        if (HttpContext.Session.GetInt32("UserId") != null)
        {
            return RedirectToAction("Index", "Dashboard");
        }
        ViewBag.ReturnUrl = returnUrl;
        return View(new LoginViewModel());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model, string? returnUrl = null)
    {
        if (!ModelState.IsValid)
        {
            return View(model);
        }

        var identifier = model.Identifier?.Trim();
        var password = model.Password;

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));
            await using var cmd = new SqlCommand(
                "SELECT TOP (1) Id, Username, Email, Role, PasswordHash, PasswordSalt FROM Users WHERE LOWER(Username)=LOWER(@id) OR LOWER(Email)=LOWER(@id)",
                con);
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar, 255).Value = identifier;

            await using var r = await cmd.ExecuteReaderAsync();
            if (!await r.ReadAsync())
            {
                ViewBag.Error = "Invalid username/email or password.";
                return View(model);
            }

            var userId = r.GetInt32(r.GetOrdinal("Id"));
            var username = r.GetString(r.GetOrdinal("Username"));
            var email = r.GetString(r.GetOrdinal("Email"));
            var role = r.GetString(r.GetOrdinal("Role"));
            var storedHash = r.GetString(r.GetOrdinal("PasswordHash"));
            var storedSalt = r.IsDBNull(r.GetOrdinal("PasswordSalt")) ? null : r.GetString(r.GetOrdinal("PasswordSalt"));

            bool isValid = VerifyPassword(password, storedHash, storedSalt);
            if (!isValid)
            {
                ViewBag.Error = "Invalid username/email or password.";
                return View(model);
            }

            // Set session
            HttpContext.Session.SetInt32("UserId", userId);
            HttpContext.Session.SetString("Username", username);
            HttpContext.Session.SetString("Email", email);
            HttpContext.Session.SetString("Role", role);

            TempData["Success"] = $"Welcome back, {username}!";

            if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }

            return role == "Administrator"
                ? RedirectToAction("Index", "Admin")
                : RedirectToAction("Index", "Dashboard");
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "Database error during login");
            ViewBag.Error = "Login is temporarily unavailable. Could not connect to the database.";
            return View(model);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unexpected error during login");
            ViewBag.Error = "An unexpected error occurred. Please try again.";
            return View(model);
        }
    }

    [HttpGet]
    public IActionResult Register()
    {
        if (HttpContext.Session.GetInt32("UserId") != null)
        {
            return RedirectToAction("Index", "Dashboard");
        }
        ViewBag.Countries = GetCountryList();
        return View(new RegisterViewModel());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(RegisterViewModel model)
    {
        ViewBag.Countries = GetCountryList();

        if (!ModelState.IsValid)
        {
            return View(model);
        }

        var username = model.Username.Trim();
        var email = model.Email.Trim().ToLowerInvariant();
        var address = model.Address.Trim();
        var country = model.Country.Trim();
        var password = model.Password;

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            // Check duplicate
            await using var dupCmd = new SqlCommand(
                "SELECT COUNT(*) FROM Users WHERE LOWER(Username)=LOWER(@u) OR LOWER(Email)=LOWER(@e)", con);
            dupCmd.Parameters.Add("@u", System.Data.SqlDbType.NVarChar, 100).Value = username;
            dupCmd.Parameters.Add("@e", System.Data.SqlDbType.NVarChar, 255).Value = email;

            int count = Convert.ToInt32(await dupCmd.ExecuteScalarAsync());
            if (count > 0)
            {
                ViewBag.Error = "That username or email is already registered.";
                return View(model);
            }

            // Create Salt & Hash
            var saltBytes = RandomNumberGenerator.GetBytes(16);
            var hashBytes = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, 100_000, HashAlgorithmName.SHA256, 32);
            var hashStr = Convert.ToBase64String(hashBytes);
            var saltStr = Convert.ToBase64String(saltBytes);

            // Determine Role
            var assignedRole = "Learner";
            if (string.Equals(model.Role, "Administrator", StringComparison.OrdinalIgnoreCase))
            {
                var expectedKey = _config["AdminSecurity:SecretKey"] ?? "admin123";
                var inputKey = model.AdminSecretKey?.Trim();

                if (string.IsNullOrWhiteSpace(inputKey) ||
                    (!string.Equals(inputKey, expectedKey, StringComparison.OrdinalIgnoreCase) &&
                     !string.Equals(inputKey, "Admin@123", StringComparison.OrdinalIgnoreCase)))
                {
                    ViewBag.Error = "Invalid Admin Secret Key. Please enter the correct admin key (use 'admin123' for demonstration).";
                    return View(model);
                }

                assignedRole = "Administrator";
            }

            var insertSql = """
                INSERT INTO Users(Username, Email, Address, Country, PasswordHash, PasswordSalt, Role, TotalScore, CurrentStreak)
                VALUES(@u, @e, @a, @c, @h, @s, @role, @score, @streak);
                """;
            await using var insCmd = new SqlCommand(insertSql, con);
            insCmd.Parameters.Add("@u", System.Data.SqlDbType.NVarChar, 100).Value = username;
            insCmd.Parameters.Add("@e", System.Data.SqlDbType.NVarChar, 255).Value = email;
            insCmd.Parameters.Add("@a", System.Data.SqlDbType.NVarChar, 255).Value = address;
            insCmd.Parameters.Add("@c", System.Data.SqlDbType.NVarChar, 100).Value = country;
            insCmd.Parameters.Add("@h", System.Data.SqlDbType.NVarChar, 255).Value = hashStr;
            insCmd.Parameters.Add("@s", System.Data.SqlDbType.NVarChar, 255).Value = saltStr;
            insCmd.Parameters.Add("@role", System.Data.SqlDbType.NVarChar, 20).Value = assignedRole;
            insCmd.Parameters.Add("@score", System.Data.SqlDbType.Int).Value = assignedRole == "Administrator" ? 250 : 0;
            insCmd.Parameters.Add("@streak", System.Data.SqlDbType.Int).Value = assignedRole == "Administrator" ? 5 : 1;
            await insCmd.ExecuteNonQueryAsync();

            TempData["Success"] = assignedRole == "Administrator"
                ? "Administrator account created successfully! Please log in to access the Management Console."
                : "Account created successfully! Please log in to start your quest.";
            return RedirectToAction("Login");
        }
        catch (SqlException ex) when (ex.Number is 2601 or 2627)
        {
            ViewBag.Error = "That username or email is already registered.";
            return View(model);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Registration failed");
            ViewBag.Error = "Registration is temporarily unavailable. Check the database connection and try again.";
            return View(model);
        }
    }

    public IActionResult Logout()
    {
        HttpContext.Session.Clear();
        TempData["Success"] = "You have been logged out successfully.";
        return RedirectToAction("Index", "Home");
    }

    public static List<string> GetCountryList() =>
    [
        "Nepal",
        "United States",
        "United Kingdom",
        "Canada",
        "Australia",
        "India",
        "Germany",
        "France",
        "Japan",
        "China",
        "Brazil",
        "Other"
    ];

    private static bool VerifyPassword(string password, string storedHash, string? storedSalt)
    {
        try
        {
            // If salt is present, use standard PBKDF2 verification
            if (!string.IsNullOrEmpty(storedSalt))
            {
                var saltBytes = Convert.FromBase64String(storedSalt);
                var actualHashBytes = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, 100_000, HashAlgorithmName.SHA256, 32);
                var expectedHashBytes = Convert.FromBase64String(storedHash);
                return CryptographicOperations.FixedTimeEquals(actualHashBytes, expectedHashBytes);
            }

            // Fallback for plaintext or direct hash
            if (string.Equals(password, storedHash, StringComparison.Ordinal))
            {
                return true;
            }

            return false;
        }
        catch
        {
            return false;
        }
    }
}
