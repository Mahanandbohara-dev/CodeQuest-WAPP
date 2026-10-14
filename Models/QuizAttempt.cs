// Models/QuizAttempt.cs (Create this new file)
namespace CodeQuest.Models
{
    public class QuizAttempt
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int QuestionId { get; set; }
        public int Score { get; set; }
        public DateTime AttemptedOn { get; set; }
    }
}