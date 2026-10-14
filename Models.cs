using System.ComponentModel.DataAnnotations;

namespace CodeQuest.Models;

public class User
{
    public int Id { get; set; }
    public string Username { get; set; } = "";
    public string Email { get; set; } = "";
    public string? Address { get; set; }
    public string? Country { get; set; }
    public string PasswordHash { get; set; } = "";
    public string? PasswordSalt { get; set; }
    public string Role { get; set; } = "Learner";
    public int TotalScore { get; set; }
    public int CurrentStreak { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public class RegisterViewModel
{
    [Required(ErrorMessage = "Username is required.")]
    [StringLength(50, MinimumLength = 3, ErrorMessage = "Username must be between 3 and 50 characters.")]
    public string Username { get; set; } = "";

    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Invalid email address.")]
    public string Email { get; set; } = "";

    [Required(ErrorMessage = "Address is required.")]
    [StringLength(200, ErrorMessage = "Address cannot exceed 200 characters.")]
    public string Address { get; set; } = "";

    [Required(ErrorMessage = "Please select a country.")]
    public string Country { get; set; } = "";

    [Required(ErrorMessage = "Password is required.")]
    [MinLength(6, ErrorMessage = "Password must be at least 6 characters.")]
    public string Password { get; set; } = "";

    [Required(ErrorMessage = "Please confirm your password.")]
    [Compare("Password", ErrorMessage = "Passwords do not match.")]
    public string ConfirmPassword { get; set; } = "";

    public string Role { get; set; } = "Learner";

    public string? AdminSecretKey { get; set; }
}

public class LoginViewModel
{
    [Required(ErrorMessage = "Username or Email is required.")]
    public string Identifier { get; set; } = "";

    [Required(ErrorMessage = "Password is required.")]
    public string Password { get; set; } = "";

    public bool RememberMe { get; set; }
}

public class UserProfileViewModel
{
    public int Id { get; set; }
    public string Username { get; set; } = "";
    public string Email { get; set; } = "";
    public string Address { get; set; } = "";
    public string Country { get; set; } = "";
    public string Role { get; set; } = "Learner";
    public int TotalScore { get; set; }
    public int CurrentStreak { get; set; }
    public List<BadgeItem> Badges { get; set; } = [];
    public List<QuizAttemptItem> RecentAttempts { get; set; } = [];
}

public class EditProfileViewModel
{
    public int Id { get; set; }
    public string Username { get; set; } = "";

    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Invalid email address.")]
    public string Email { get; set; } = "";

    [Required(ErrorMessage = "Address is required.")]
    [StringLength(200, ErrorMessage = "Address cannot exceed 200 characters.")]
    public string Address { get; set; } = "";

    [Required(ErrorMessage = "Please select a country.")]
    public string Country { get; set; } = "";
}

public class BadgeItem
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public string Description { get; set; } = "";
    public string Icon { get; set; } = "🏅";
    public DateTime EarnedAt { get; set; }
}

public class QuizAttemptItem
{
    public int Id { get; set; }
    public string Language { get; set; } = "";
    public int Score { get; set; }
    public int TotalQuestions { get; set; }
    public DateTime AttemptedAt { get; set; }
}

public class LeaderboardUserViewModel
{
    public int Rank { get; set; }
    public string Username { get; set; } = "";
    public string Country { get; set; } = "";
    public string Role { get; set; } = "";
    public int TotalScore { get; set; }
    public int CurrentStreak { get; set; }
    public int BadgesCount { get; set; }
}

public class QuizQuestion
{
    public int Id { get; set; }
    public string Language { get; set; } = "";
    public string Difficulty { get; set; } = "Beginner";
    public string Question { get; set; } = "";
    public string OptionA { get; set; } = "";
    public string OptionB { get; set; } = "";
    public string OptionC { get; set; } = "";
    public string OptionD { get; set; } = "";
    public string CorrectOption { get; set; } = "";
    public string Explanation { get; set; } = "";
}

public class QuizViewModel
{
    public string Language { get; set; } = "Python";
    public List<QuizQuestion> Questions { get; set; } = [];
    public int CurrentIndex { get; set; } = 0;
    public int TotalQuestions => Questions.Count;
}

public class QuizSubmitModel
{
    public string Language { get; set; } = "";
    public List<QuizAnswerSubmission> Answers { get; set; } = [];
}

public class QuizAnswerSubmission
{
    public int QuestionId { get; set; }
    public string SelectedOption { get; set; } = "";
}

public class QuizResultViewModel
{
    public string Language { get; set; } = "";
    public int Score { get; set; }
    public int TotalQuestions { get; set; }
    public int CorrectCount { get; set; }
    public bool PerfectScore => CorrectCount == TotalQuestions && TotalQuestions > 0;
    public List<QuestionReviewItem> Reviews { get; set; } = [];
    public List<string> UnlockedBadges { get; set; } = [];
}

public class QuestionReviewItem
{
    public string Question { get; set; } = "";
    public string SelectedOption { get; set; } = "";
    public string CorrectOption { get; set; } = "";
    public string Explanation { get; set; } = "";
    public bool IsCorrect { get; set; }
}

public class AdminDashboardViewModel
{
    public int TotalUsers { get; set; }
    public int TotalQuestions { get; set; }
    public int TotalAttempts { get; set; }
    public double AverageScore { get; set; }
    public List<AdminUserViewModel> Users { get; set; } = [];
    public List<AdminQuestionViewModel> Questions { get; set; } = [];
    public List<QuizAttemptItem> RecentAttempts { get; set; } = [];
}

public class AdminUserViewModel
{
    public int Id { get; set; }
    public string Username { get; set; } = "";
    public string Email { get; set; } = "";
    public string Address { get; set; } = "";
    public string Country { get; set; } = "";
    public string Role { get; set; } = "";
    public int TotalScore { get; set; }
    public int CurrentStreak { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class AdminQuestionViewModel
{
    public int Id { get; set; }
    public string Language { get; set; } = "";
    public string Difficulty { get; set; } = "";
    public string QuestionText { get; set; } = "";
    public string OptionA { get; set; } = "";
    public string OptionB { get; set; } = "";
    public string OptionC { get; set; } = "";
    public string OptionD { get; set; } = "";
    public string CorrectOption { get; set; } = "";
    public string Explanation { get; set; } = "";
}

public class AskAiRequest
{
    public string Question { get; set; } = "";
    public string Topic { get; set; } = "";
}

public class ChatMessageItem
{
    public string Role { get; set; } = "user"; // "user" or "assistant"
    public string Content { get; set; } = "";
}

public class AiChatRequest
{
    public string Message { get; set; } = "";
    public List<ChatMessageItem> History { get; set; } = [];
}
