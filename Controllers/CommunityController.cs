using CodeQuest.Data;
using CodeQuest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace CodeQuest.Controllers;

public class CommunityController : Controller
{
    private readonly IConfiguration _config;
    private readonly ILogger<CommunityController> _logger;

    public CommunityController(IConfiguration config, ILogger<CommunityController> logger)
    {
        _config = config;
        _logger = logger;
    }

    public async Task<IActionResult> Index(string? search, string? country)
    {
        var users = new List<LeaderboardUserViewModel>();

        try
        {
            await using var con = await Db.OpenAsync(_config.GetConnectionString("DefaultConnection"));

            var sql = """
                SELECT 
                    u.Id, 
                    u.Username, 
                    ISNULL(u.Country, 'Global') AS Country, 
                    u.Role, 
                    u.TotalScore, 
                    u.CurrentStreak,
                    (SELECT COUNT(*) FROM UserBadges ub WHERE ub.UserId = u.Id) AS BadgesCount
                FROM Users u
                WHERE (@s IS NULL OR u.Username LIKE '%' + @s + '%' OR u.Email LIKE '%' + @s + '%')
                  AND (@c IS NULL OR @c = '' OR u.Country = @c)
                ORDER BY u.TotalScore DESC, u.CurrentStreak DESC, u.Username ASC;
                """;

            await using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@s", string.IsNullOrWhiteSpace(search) ? DBNull.Value : search.Trim());
            cmd.Parameters.AddWithValue("@c", string.IsNullOrWhiteSpace(country) ? DBNull.Value : country.Trim());

            await using var r = await cmd.ExecuteReaderAsync();
            int rank = 1;
            while (await r.ReadAsync())
            {
                users.Add(new LeaderboardUserViewModel
                {
                    Rank = rank++,
                    Username = r.GetString(1),
                    Country = r.GetString(2),
                    Role = r.GetString(3),
                    TotalScore = r.GetInt32(4),
                    CurrentStreak = r.GetInt32(5),
                    BadgesCount = r.GetInt32(6)
                });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error querying community leaderboard");
            ViewBag.Error = "Could not load leaderboard from database.";
        }

        ViewBag.Search = search;
        ViewBag.Country = country;
        ViewBag.CountryList = AccountController.GetCountryList();

        return View(users);
    }
}
