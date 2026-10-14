using Microsoft.EntityFrameworkCore;
using CodeQuest.Models;

namespace CodeQuest.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<QuizAttempt> QuizAttempts { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            // Seed data for Q&A
            modelBuilder.Entity<Question>().HasData(
                new Question { Id = 1, Language = "Python", Level = 1, Text = "What is the output of print(2 + 3)?", OptionA = "23", OptionB = "5", OptionC = "2+3", OptionD = "Error", CorrectOption = "B", Explanation = "2 + 3 evaluates to 5." },
                new Question { Id = 2, Language = "JavaScript", Level = 1, Text = "Which keyword declares a block-scope variable?", OptionA = "var", OptionB = "let", OptionC = "const", OptionD = "int", CorrectOption = "B", Explanation = "let declares a block-scope variable." },
                new Question { Id = 3, Language = "Java", Level = 1, Text = "What does JVM stand for?", OptionA = "Java Virtual Machine", OptionB = "Java Variation Method", OptionC = "Joint Virtual Model", OptionD = "None", CorrectOption = "A", Explanation = "JVM = Java Virtual Machine." },
                new Question { Id = 4, Language = "C++", Level = 1, Text = "Which header provides std::vector?", OptionA = "<iostream>", OptionB = "<vector>", OptionC = "<string>", OptionD = "<map>", CorrectOption = "B", Explanation = "<vector> includes std::vector." },
                new Question { Id = 5, Language = "HTML", Level = 1, Text = "Which tag is used for the largest heading?", OptionA = "<h1>", OptionB = "<h6>", OptionC = "<header>", OptionD = "<title>", CorrectOption = "A", Explanation = "<h1> is the largest heading tag." },
                new Question { Id = 6, Language = "CSS", Level = 1, Text = "Which property changes text color?", OptionA = "font-color", OptionB = "text-color", OptionC = "color", OptionD = "background-color", CorrectOption = "C", Explanation = "The color property sets text color." }
            );
        }
    }
}
