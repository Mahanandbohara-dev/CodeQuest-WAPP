using CodeQuest.Data;
using CodeQuest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace CodeQuest.Controllers;

public class DashboardController : Controller
{
    private readonly IConfiguration _config;
    private readonly ILogger<DashboardController> _logger;

    public DashboardController(IConfiguration config, ILogger<DashboardController> logger)
    {
        _config = config;
        _logger = logger;
    }

    private int? CurrentUserId => HttpContext.Session.GetInt32("UserId");

    public async Task<IActionResult> Index()
    {
        if (CurrentUserId == null)
            return RedirectToAction("Login", "Account");

        int userId = CurrentUserId.Value;

        var profile = new UserProfileViewModel();

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            // 1. User Info
            await using var userCmd = new SqlCommand(
                "SELECT Id, Username, Email, Address, Country, Role, TotalScore, CurrentStreak FROM Users WHERE Id=@id", con);
            userCmd.Parameters.AddWithValue("@id", userId);

            await using (var r = await userCmd.ExecuteReaderAsync())
            {
                if (await r.ReadAsync())
                {
                    profile.Id = r.GetInt32(0);
                    profile.Username = r.GetString(1);
                    profile.Email = r.GetString(2);
                    profile.Address = r.IsDBNull(3) ? "" : r.GetString(3);
                    profile.Country = r.IsDBNull(4) ? "" : r.GetString(4);
                    profile.Role = r.GetString(5);
                    profile.TotalScore = r.GetInt32(6);
                    profile.CurrentStreak = r.GetInt32(7);
                }
                else
                {
                    HttpContext.Session.Clear();
                    return RedirectToAction("Login", "Account");
                }
            }

            // 2. Badges
            await using var badgeCmd = new SqlCommand("""
                SELECT b.Id, b.Name, b.Description, b.Icon, ub.EarnedAt
                FROM UserBadges ub
                INNER JOIN Badges b ON ub.BadgeId = b.Id
                WHERE ub.UserId = @id
                ORDER BY ub.EarnedAt DESC
                """, con);
            badgeCmd.Parameters.AddWithValue("@id", userId);

            await using (var r = await badgeCmd.ExecuteReaderAsync())
            {
                while (await r.ReadAsync())
                {
                    profile.Badges.Add(new BadgeItem
                    {
                        Id = r.GetInt32(0),
                        Name = r.GetString(1),
                        Description = r.GetString(2),
                        Icon = r.IsDBNull(3) ? "🏅" : r.GetString(3),
                        EarnedAt = r.GetDateTime(4)
                    });
                }
            }

            // 3. Recent Quiz Attempts
            await using var attemptCmd = new SqlCommand("""
                SELECT TOP (5) qa.Id, ISNULL(q.Language, 'Mixed') AS Language, qa.Score, qa.TotalQuestions, qa.AttemptedAt
                FROM QuizAttempts qa
                LEFT JOIN AttemptDetails ad ON ad.AttemptId = qa.Id
                LEFT JOIN Questions q ON q.Id = ad.QuestionId
                WHERE qa.UserId = @id
                GROUP BY qa.Id, q.Language, qa.Score, qa.TotalQuestions, qa.AttemptedAt
                ORDER BY qa.AttemptedAt DESC
                """, con);
            attemptCmd.Parameters.AddWithValue("@id", userId);

            await using (var r = await attemptCmd.ExecuteReaderAsync())
            {
                while (await r.ReadAsync())
                {
                    profile.RecentAttempts.Add(new QuizAttemptItem
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
            _logger.LogError(ex, "Error loading dashboard");
            ViewBag.Error = "Could not load complete profile data from database.";
        }

        return View(profile);
    }

    public async Task<IActionResult> Quiz(string language = "Python")
    {
        if (CurrentUserId == null)
            return RedirectToAction("Login", "Account", new { returnUrl = $"/Dashboard/Quiz?language={language}" });

        var model = new QuizViewModel { Language = language };

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));
            await using var cmd = new SqlCommand("""
                SELECT TOP (5) Id, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation
                FROM Questions
                WHERE LOWER(Language) = LOWER(@lang)
                ORDER BY NEWID()
                """, con);
            cmd.Parameters.AddWithValue("@lang", language);

            await using var r = await cmd.ExecuteReaderAsync();
            while (await r.ReadAsync())
            {
                model.Questions.Add(new QuizQuestion
                {
                    Id = r.GetInt32(0),
                    Language = r.GetString(1),
                    Difficulty = r.GetString(2),
                    Question = r.GetString(3),
                    OptionA = r.GetString(4),
                    OptionB = r.GetString(5),
                    OptionC = r.GetString(6),
                    OptionD = r.GetString(7),
                    CorrectOption = r.GetString(8),
                    Explanation = r.IsDBNull(9) ? "" : r.GetString(9)
                });
            }

            if (model.Questions.Count == 0)
            {
                ViewBag.Message = $"No questions found for {language} yet. Please check back soon or try another topic!";
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching quiz questions");
            ViewBag.Message = "Database query error while loading quiz.";
        }

        return View(model);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> SubmitQuiz([FromForm] QuizSubmitModel submission)
    {
        if (CurrentUserId == null)
            return RedirectToAction("Login", "Account");

        int userId = CurrentUserId.Value;

        if (submission == null || submission.Answers == null || submission.Answers.Count == 0)
        {
            return RedirectToAction("Index");
        }

        var result = new QuizResultViewModel
        {
            Language = submission.Language,
            TotalQuestions = submission.Answers.Count
        };

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            // 1. Evaluate answers
            int correctCount = 0;
            var detailsToInsert = new List<(int QuestionId, string SelectedOption, bool IsCorrect)>();

            foreach (var ans in submission.Answers)
            {
                await using var qCmd = new SqlCommand(
                    "SELECT QuestionText, CorrectOption, Explanation FROM Questions WHERE Id=@id", con);
                qCmd.Parameters.AddWithValue("@id", ans.QuestionId);

                await using var qr = await qCmd.ExecuteReaderAsync();
                if (await qr.ReadAsync())
                {
                    var qText = qr.GetString(0);
                    var correctOpt = qr.GetString(1).Trim().ToUpper();
                    var explanation = qr.IsDBNull(2) ? "" : qr.GetString(2);
                    var selected = ans.SelectedOption?.Trim().ToUpper() ?? "";

                    bool isCorrect = selected == correctOpt;
                    if (isCorrect) correctCount++;

                    result.Reviews.Add(new QuestionReviewItem
                    {
                        Question = qText,
                        SelectedOption = selected,
                        CorrectOption = correctOpt,
                        Explanation = explanation,
                        IsCorrect = isCorrect
                    });

                    detailsToInsert.Add((ans.QuestionId, selected, isCorrect));
                }
            }

            result.CorrectCount = correctCount;
            result.Score = correctCount * 10;

            // 2. Save QuizAttempt
            await using var attemptCmd = new SqlCommand("""
                INSERT INTO QuizAttempts(UserId, Score, TotalQuestions, AttemptedAt)
                OUTPUT INSERTED.Id
                VALUES(@u, @s, @t, SYSUTCDATETIME());
                """, con);
            attemptCmd.Parameters.AddWithValue("@u", userId);
            attemptCmd.Parameters.AddWithValue("@s", result.Score);
            attemptCmd.Parameters.AddWithValue("@t", result.TotalQuestions);

            int attemptId = Convert.ToInt32(await attemptCmd.ExecuteScalarAsync());

            // 3. Save AttemptDetails
            foreach (var d in detailsToInsert)
            {
                await using var dCmd = new SqlCommand("""
                    INSERT INTO AttemptDetails(AttemptId, QuestionId, SelectedOption, IsCorrect)
                    VALUES(@a, @q, @o, @c);
                    """, con);
                dCmd.Parameters.AddWithValue("@a", attemptId);
                dCmd.Parameters.AddWithValue("@q", d.QuestionId);
                dCmd.Parameters.AddWithValue("@o", (object?)d.SelectedOption ?? DBNull.Value);
                dCmd.Parameters.AddWithValue("@c", d.IsCorrect);
                await dCmd.ExecuteNonQueryAsync();
            }

            // 4. Update User's TotalScore
            await using var userUpdateCmd = new SqlCommand(
                "UPDATE Users SET TotalScore = TotalScore + @s WHERE Id = @u", con);
            userUpdateCmd.Parameters.AddWithValue("@s", result.Score);
            userUpdateCmd.Parameters.AddWithValue("@u", userId);
            await userUpdateCmd.ExecuteNonQueryAsync();

            // 5. Update Streak
            await UpdateStreakAsync(con, userId);

            // 6. Check and Award Badges
            result.UnlockedBadges = await CheckAndAwardBadgesAsync(con, userId, result);

            return View("Result", result);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing quiz submission");
            TempData["Error"] = "Error saving your quiz results.";
            return RedirectToAction("Index");
        }
    }

    private static async Task UpdateStreakAsync(SqlConnection con, int userId)
    {
        var today = DateTime.UtcNow.Date;

        await using var streakCmd = new SqlCommand(
            "SELECT CurrentStreak, LastActivityDate FROM Streaks WHERE UserId=@u", con);
        streakCmd.Parameters.AddWithValue("@u", userId);

        await using var r = await streakCmd.ExecuteReaderAsync();
        if (await r.ReadAsync())
        {
            int current = r.GetInt32(0);
            DateTime? lastDate = r.IsDBNull(1) ? null : r.GetDateTime(1).Date;
            r.Close();

            if (lastDate == null || lastDate.Value < today.AddDays(-1))
            {
                current = 1; // Streak reset
            }
            else if (lastDate.Value == today.AddDays(-1))
            {
                current += 1; // Consecutive day
            }
            // If already active today, streak remains current

            await using var updateCmd = new SqlCommand("""
                UPDATE Streaks SET CurrentStreak=@s, LastActivityDate=@d WHERE UserId=@u;
                UPDATE Users SET CurrentStreak=@s WHERE Id=@u;
                """, con);
            updateCmd.Parameters.AddWithValue("@s", current);
            updateCmd.Parameters.AddWithValue("@d", today);
            updateCmd.Parameters.AddWithValue("@u", userId);
            await updateCmd.ExecuteNonQueryAsync();
        }
        else
        {
            r.Close();
            await using var insertCmd = new SqlCommand("""
                INSERT INTO Streaks(UserId, CurrentStreak, LastActivityDate) VALUES(@u, 1, @d);
                UPDATE Users SET CurrentStreak=1 WHERE Id=@u;
                """, con);
            insertCmd.Parameters.AddWithValue("@u", userId);
            insertCmd.Parameters.AddWithValue("@d", today);
            await insertCmd.ExecuteNonQueryAsync();
        }
    }

    private static async Task<List<string>> CheckAndAwardBadgesAsync(SqlConnection con, int userId, QuizResultViewModel result)
    {
        var awarded = new List<string>();

        // 1. "First Quest" (BadgeId 1)
        await using var attemptCountCmd = new SqlCommand("SELECT COUNT(*) FROM QuizAttempts WHERE UserId=@u", con);
        attemptCountCmd.Parameters.AddWithValue("@u", userId);
        int totalAttempts = Convert.ToInt32(await attemptCountCmd.ExecuteScalarAsync());

        if (totalAttempts >= 1)
        {
            if (await AwardBadgeIfNotEarned(con, userId, "First Quest"))
                awarded.Add("First Quest 🎯");
        }

        // 2. "Perfect Score" (100% on this quiz)
        if (result.PerfectScore)
        {
            if (await AwardBadgeIfNotEarned(con, userId, "Perfect Score"))
                awarded.Add("Perfect Score ⭐");
        }

        // 3. "Code Master" (Total score >= 100)
        await using var scoreCmd = new SqlCommand("SELECT TotalScore FROM Users WHERE Id=@u", con);
        scoreCmd.Parameters.AddWithValue("@u", userId);
        int totalScore = Convert.ToInt32(await scoreCmd.ExecuteScalarAsync());

        if (totalScore >= 100)
        {
            if (await AwardBadgeIfNotEarned(con, userId, "Code Master"))
                awarded.Add("Code Master 👑");
        }

        // 4. "Topic Explorer" (attempts across 3+ different languages)
        await using var topicsCmd = new SqlCommand("""
            SELECT COUNT(DISTINCT q.Language)
            FROM QuizAttempts qa
            JOIN AttemptDetails ad ON ad.AttemptId = qa.Id
            JOIN Questions q ON q.Id = ad.QuestionId
            WHERE qa.UserId = @u
            """, con);
        topicsCmd.Parameters.AddWithValue("@u", userId);
        int topicCount = Convert.ToInt32(await topicsCmd.ExecuteScalarAsync());

        if (topicCount >= 3)
        {
            if (await AwardBadgeIfNotEarned(con, userId, "Topic Explorer"))
                awarded.Add("Topic Explorer 🧭");
        }

        return awarded;
    }

    private static async Task<bool> AwardBadgeIfNotEarned(SqlConnection con, int userId, string badgeName)
    {
        await using var cmd = new SqlCommand("""
            IF NOT EXISTS (
                SELECT 1 FROM UserBadges ub 
                JOIN Badges b ON ub.BadgeId = b.Id 
                WHERE ub.UserId = @u AND b.Name = @bn
            )
            BEGIN
                INSERT INTO UserBadges(UserId, BadgeId, EarnedAt)
                SELECT @u, Id, SYSUTCDATETIME() FROM Badges WHERE Name = @bn;
                SELECT 1;
            END
            ELSE
                SELECT 0;
            """, con);
        cmd.Parameters.AddWithValue("@u", userId);
        cmd.Parameters.AddWithValue("@bn", badgeName);

        var res = await cmd.ExecuteScalarAsync();
        return res != null && Convert.ToInt32(res) == 1;
    }

    [HttpGet]
    public async Task<IActionResult> EditProfile()
    {
        if (CurrentUserId == null)
            return RedirectToAction("Login", "Account");

        int userId = CurrentUserId.Value;
        var model = new EditProfileViewModel();

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));
            await using var cmd = new SqlCommand("SELECT Id, Username, Email, Address, Country FROM Users WHERE Id = @id", con);
            cmd.Parameters.AddWithValue("@id", userId);

            await using var r = await cmd.ExecuteReaderAsync();
            if (await r.ReadAsync())
            {
                model.Id = r.GetInt32(0);
                model.Username = r.GetString(1);
                model.Email = r.GetString(2);
                model.Address = r.IsDBNull(3) ? "" : r.GetString(3);
                model.Country = r.IsDBNull(4) ? "" : r.GetString(4);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching profile for edit");
            TempData["Error"] = "Unable to load profile data.";
            return RedirectToAction("Index");
        }

        return View(model);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> EditProfile(EditProfileViewModel model)
    {
        if (CurrentUserId == null)
            return RedirectToAction("Login", "Account");

        int userId = CurrentUserId.Value;

        if (!ModelState.IsValid)
        {
            return View(model);
        }

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            // Check if email is already taken by another user
            await using var checkEmail = new SqlCommand("SELECT COUNT(*) FROM Users WHERE LOWER(Email) = LOWER(@email) AND Id <> @id", con);
            checkEmail.Parameters.AddWithValue("@email", model.Email.Trim());
            checkEmail.Parameters.AddWithValue("@id", userId);
            int emailExists = Convert.ToInt32(await checkEmail.ExecuteScalarAsync());

            if (emailExists > 0)
            {
                ModelState.AddModelError("Email", "This email address is already in use by another account.");
                return View(model);
            }

            await using var updateCmd = new SqlCommand("""
                UPDATE Users
                SET Email = @email,
                    Address = @address,
                    Country = @country
                WHERE Id = @id
                """, con);
            updateCmd.Parameters.AddWithValue("@email", model.Email.Trim());
            updateCmd.Parameters.AddWithValue("@address", model.Address.Trim());
            updateCmd.Parameters.AddWithValue("@country", model.Country);
            updateCmd.Parameters.AddWithValue("@id", userId);

            await updateCmd.ExecuteNonQueryAsync();

            TempData["Success"] = "Your profile has been updated successfully!";
            return RedirectToAction("Index");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating profile");
            ModelState.AddModelError("", "An error occurred while saving your changes. Please try again.");
            return View(model);
        }
    }

    [HttpGet]
    public IActionResult Games()
    {
        if (CurrentUserId == null)
            return RedirectToAction("Login", "Account");

        return View();
    }
}
