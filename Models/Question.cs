using System.ComponentModel.DataAnnotations;

namespace CodeQuest.Models
{
    public class Question
    {
        public int Id { get; set; }
        [Required]
        public string Language { get; set; } = "";
        public int Level { get; set; }
        [Required]
        public string Text { get; set; } = "";
        public string OptionA { get; set; } = "";
        public string OptionB { get; set; } = "";
        public string OptionC { get; set; } = "";
        public string OptionD { get; set; } = "";
        [Required]
        public string CorrectOption { get; set; } = "";
        public string Explanation { get; set; } = "";
    }
}
