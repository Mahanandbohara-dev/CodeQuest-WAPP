using System.Data;
using System.Security.Cryptography;
using Microsoft.Data.SqlClient;

namespace CodeQuest.Data;

public static class DbInitializer
{
    public static async Task InitializeAsync(IConfiguration configuration, ILogger logger)
    {
        var connectionString = configuration.GetConnectionString("DefaultConnection");
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            logger.LogWarning("DefaultConnection is not configured.");
            return;
        }

        try
        {
            await EnsureDatabaseExistsAsync(connectionString, logger);
            await EnsureSchemaAndSeedAsync(connectionString, logger);
            logger.LogInformation("CodeQuest database initialized successfully.");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while initializing the CodeQuest database.");
        }
    }

    private static async Task EnsureDatabaseExistsAsync(string connectionString, ILogger logger)
    {
        var builder = new SqlConnectionStringBuilder(connectionString);
        var targetDb = builder.InitialCatalog;
        if (string.IsNullOrWhiteSpace(targetDb)) return;

        builder.InitialCatalog = "master";
        var masterConnStr = builder.ConnectionString;

        await using var con = new SqlConnection(masterConnStr);
        await con.OpenAsync();

        await using var checkCmd = new SqlCommand("SELECT DB_ID(@name)", con);
        checkCmd.Parameters.AddWithValue("@name", targetDb);
        var dbId = await checkCmd.ExecuteScalarAsync();

        if (dbId == null || dbId == DBNull.Value)
        {
            logger.LogInformation("Database {Database} not found. Creating...", targetDb);
            await using var createCmd = new SqlCommand($"CREATE DATABASE [{targetDb}]", con);
            await createCmd.ExecuteNonQueryAsync();
            logger.LogInformation("Database {Database} created.", targetDb);
        }
    }

    private static async Task EnsureSchemaAndSeedAsync(string connectionString, ILogger logger)
    {
        await using var con = new SqlConnection(connectionString);
        await con.OpenAsync();

        // 1. Tables
        var ddl = """
            IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.Users (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
                    Username NVARCHAR(100) NOT NULL CONSTRAINT UQ_Users_Username UNIQUE,
                    Email NVARCHAR(255) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
                    Address NVARCHAR(255) NULL,
                    Country NVARCHAR(100) NULL,
                    PasswordHash NVARCHAR(255) NOT NULL,
                    PasswordSalt NVARCHAR(255) NULL,
                    Role NVARCHAR(20) NOT NULL CONSTRAINT DF_Users_Role DEFAULT N'Learner',
                    TotalScore INT NOT NULL CONSTRAINT DF_Users_TotalScore DEFAULT 0,
                    CurrentStreak INT NOT NULL CONSTRAINT DF_Users_CurrentStreak DEFAULT 0,
                    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
                    CONSTRAINT CK_Users_Role CHECK (Role IN (N'Learner', N'Administrator'))
                );
            END;

            IF COL_LENGTH(N'dbo.Users', N'Address') IS NULL
                ALTER TABLE dbo.Users ADD Address NVARCHAR(255) NULL;

            IF COL_LENGTH(N'dbo.Users', N'Country') IS NULL
                ALTER TABLE dbo.Users ADD Country NVARCHAR(100) NULL;

            IF COL_LENGTH(N'dbo.Users', N'PasswordSalt') IS NULL
                ALTER TABLE dbo.Users ADD PasswordSalt NVARCHAR(255) NULL;

            IF COL_LENGTH(N'dbo.Users', N'CreatedAt') IS NULL
                ALTER TABLE dbo.Users ADD CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME();

            IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.Categories (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
                    Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_Categories_Name UNIQUE
                );
            END;

            IF OBJECT_ID(N'dbo.Questions', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.Questions (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Questions PRIMARY KEY,
                    CategoryId INT NULL,
                    Language NVARCHAR(50) NOT NULL,
                    Difficulty NVARCHAR(20) NOT NULL,
                    QuestionText NVARCHAR(MAX) NOT NULL,
                    OptionA NVARCHAR(500) NOT NULL,
                    OptionB NVARCHAR(500) NOT NULL,
                    OptionC NVARCHAR(500) NOT NULL,
                    OptionD NVARCHAR(500) NOT NULL,
                    CorrectOption CHAR(1) NOT NULL,
                    Explanation NVARCHAR(MAX) NULL,
                    CONSTRAINT CK_Questions_Difficulty CHECK (Difficulty IN (N'Beginner', N'Intermediate', N'Advanced')),
                    CONSTRAINT CK_Questions_CorrectOption CHECK (CorrectOption IN ('A', 'B', 'C', 'D')),
                    CONSTRAINT FK_Questions_Categories FOREIGN KEY (CategoryId)
                        REFERENCES dbo.Categories(Id) ON DELETE SET NULL
                );
            END;

            IF OBJECT_ID(N'dbo.QuizAttempts', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.QuizAttempts (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_QuizAttempts PRIMARY KEY,
                    UserId INT NOT NULL,
                    Score INT NOT NULL,
                    TotalQuestions INT NOT NULL,
                    AttemptedAt DATETIME2 NOT NULL CONSTRAINT DF_QuizAttempts_AttemptedAt DEFAULT SYSUTCDATETIME(),
                    CONSTRAINT FK_QuizAttempts_Users FOREIGN KEY (UserId)
                        REFERENCES dbo.Users(Id) ON DELETE CASCADE
                );
            END;

            IF OBJECT_ID(N'dbo.AttemptDetails', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.AttemptDetails (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_AttemptDetails PRIMARY KEY,
                    AttemptId INT NOT NULL,
                    QuestionId INT NOT NULL,
                    SelectedOption CHAR(1) NULL,
                    IsCorrect BIT NOT NULL,
                    CONSTRAINT FK_AttemptDetails_Attempts FOREIGN KEY (AttemptId)
                        REFERENCES dbo.QuizAttempts(Id) ON DELETE CASCADE,
                    CONSTRAINT FK_AttemptDetails_Questions FOREIGN KEY (QuestionId)
                        REFERENCES dbo.Questions(Id) ON DELETE CASCADE
                );
            END;

            IF OBJECT_ID(N'dbo.Badges', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.Badges (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Badges PRIMARY KEY,
                    Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_Badges_Name UNIQUE,
                    Description NVARCHAR(255) NOT NULL,
                    Icon NVARCHAR(50) NOT NULL CONSTRAINT DF_Badges_Icon DEFAULT N'🏅'
                );
            END;

            IF COL_LENGTH(N'dbo.Badges', N'Icon') IS NULL
                ALTER TABLE dbo.Badges ADD Icon NVARCHAR(50) NOT NULL CONSTRAINT DF_Badges_Icon DEFAULT N'🏅';

            IF OBJECT_ID(N'dbo.UserBadges', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.UserBadges (
                    UserId INT NOT NULL,
                    BadgeId INT NOT NULL,
                    EarnedAt DATETIME2 NOT NULL CONSTRAINT DF_UserBadges_EarnedAt DEFAULT SYSUTCDATETIME(),
                    CONSTRAINT PK_UserBadges PRIMARY KEY (UserId, BadgeId),
                    CONSTRAINT FK_UserBadges_Users FOREIGN KEY (UserId)
                        REFERENCES dbo.Users(Id) ON DELETE CASCADE,
                    CONSTRAINT FK_UserBadges_Badges FOREIGN KEY (BadgeId)
                        REFERENCES dbo.Badges(Id) ON DELETE CASCADE
                );
            END;

            IF OBJECT_ID(N'dbo.Streaks', N'U') IS NULL
            BEGIN
                CREATE TABLE dbo.Streaks (
                    UserId INT NOT NULL CONSTRAINT PK_Streaks PRIMARY KEY,
                    CurrentStreak INT NOT NULL CONSTRAINT DF_Streaks_CurrentStreak DEFAULT 0,
                    LastActivityDate DATE NULL,
                    CONSTRAINT FK_Streaks_Users FOREIGN KEY (UserId)
                        REFERENCES dbo.Users(Id) ON DELETE CASCADE
                );
            END;
            """;

        await using (var cmd = new SqlCommand(ddl, con))
        {
            await cmd.ExecuteNonQueryAsync();
        }

        // 2. Categories
        string[] categories = ["Python", "JavaScript", "Java", "C++", "HTML", "CSS", "SQL"];
        foreach (var cat in categories)
        {
            var catSql = "IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name=@c) INSERT INTO dbo.Categories(Name) VALUES(@c);";
            await using var cmd = new SqlCommand(catSql, con);
            cmd.Parameters.AddWithValue("@c", cat);
            await cmd.ExecuteNonQueryAsync();
        }

        // 3. Badges
        var badges = new (string Name, string Desc, string Icon)[]
        {
            ("First Quest", "Completed your very first coding quiz.", "🎯"),
            ("7 Day Streak", "Maintained a consistent learning streak.", "🔥"),
            ("Perfect Score", "Scored 100% on a quiz session.", "⭐"),
            ("Topic Explorer", "Tackled challenges across multiple technologies.", "🧭"),
            ("Code Master", "Accumulated over 100 learning points.", "👑")
        };

        foreach (var (name, desc, icon) in badges)
        {
            var badgeSql = """
                IF NOT EXISTS (SELECT 1 FROM dbo.Badges WHERE Name=@n)
                    INSERT INTO dbo.Badges(Name, Description, Icon) VALUES(@n, @d, @i);
                """;
            await using var cmd = new SqlCommand(badgeSql, con);
            cmd.Parameters.AddWithValue("@n", name);
            cmd.Parameters.AddWithValue("@d", desc);
            cmd.Parameters.AddWithValue("@i", icon);
            await cmd.ExecuteNonQueryAsync();
        }

        // 4. Default Admin and Sample Users
        await EnsureUserAsync(con, "admin", "admin@codequest.com", "Admin@123", "Kathmandu, Bagmati", "Nepal", "Administrator", 250, 5);
        await EnsureUserAsync(con, "prabit", "prabit@gmail.com", "User@123", "Pepsicola, Kathmandu", "Nepal", "Learner", 120, 3);
        await EnsureUserAsync(con, "alex_dev", "alex@example.com", "User@123", "San Francisco, CA", "United States", "Learner", 80, 2);

        // 5. Seed Comprehensive Questions
        await SeedQuestionsAsync(con);
    }

    private static async Task EnsureUserAsync(SqlConnection con, string username, string email, string password, string address, string country, string role, int score, int streak)
    {
        await using var checkCmd = new SqlCommand("SELECT COUNT(*) FROM dbo.Users WHERE Username=@u OR Email=@e", con);
        checkCmd.Parameters.AddWithValue("@u", username);
        checkCmd.Parameters.AddWithValue("@e", email);
        var count = Convert.ToInt32(await checkCmd.ExecuteScalarAsync());

        if (count == 0)
        {
            var saltBytes = RandomNumberGenerator.GetBytes(16);
            var hashBytes = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, 100_000, HashAlgorithmName.SHA256, 32);
            var hashStr = Convert.ToBase64String(hashBytes);
            var saltStr = Convert.ToBase64String(saltBytes);

            var insertSql = """
                INSERT INTO dbo.Users(Username, Email, Address, Country, PasswordHash, PasswordSalt, Role, TotalScore, CurrentStreak)
                VALUES(@u, @e, @a, @c, @h, @s, @r, @score, @streak);
                """;
            await using var insertCmd = new SqlCommand(insertSql, con);
            insertCmd.Parameters.AddWithValue("@u", username);
            insertCmd.Parameters.AddWithValue("@e", email);
            insertCmd.Parameters.AddWithValue("@a", (object)address ?? DBNull.Value);
            insertCmd.Parameters.AddWithValue("@c", (object)country ?? DBNull.Value);
            insertCmd.Parameters.AddWithValue("@h", hashStr);
            insertCmd.Parameters.AddWithValue("@s", saltStr);
            insertCmd.Parameters.AddWithValue("@r", role);
            insertCmd.Parameters.AddWithValue("@score", score);
            insertCmd.Parameters.AddWithValue("@streak", streak);
            await insertCmd.ExecuteNonQueryAsync();

            // Give admin and prabit initial badges
            await using var idCmd = new SqlCommand("SELECT Id FROM dbo.Users WHERE Username=@u", con);
            idCmd.Parameters.AddWithValue("@u", username);
            var uidObj = await idCmd.ExecuteScalarAsync();
            if (uidObj != null)
            {
                int uid = Convert.ToInt32(uidObj);
                var badgeSql = """
                    IF NOT EXISTS (SELECT 1 FROM dbo.UserBadges WHERE UserId=@uid AND BadgeId=1)
                        INSERT INTO dbo.UserBadges(UserId, BadgeId) VALUES(@uid, 1);
                    """;
                await using var ubCmd = new SqlCommand(badgeSql, con);
                ubCmd.Parameters.AddWithValue("@uid", uid);
                await ubCmd.ExecuteNonQueryAsync();
            }
        }
    }

    private static async Task SeedQuestionsAsync(SqlConnection con)
    {
        var questions = new (string Lang, string Diff, string Q, string A, string B, string C, string D, char Correct, string Exp)[]
        {
            // Python
            ("Python", "Beginner", "Which keyword defines a function in Python?", "func", "def", "function", "define", 'B', "Python uses the def keyword to define a function."),
            ("Python", "Beginner", "Which data type is immutable in Python?", "list", "dict", "set", "tuple", 'D', "Tuples cannot be modified after creation, making them immutable."),
            ("Python", "Beginner", "What is the output of len(['a', 'b', 'c'])?", "2", "3", "4", "Error", 'B', "The list contains 3 items, so len returns 3."),
            ("Python", "Intermediate", "What does the 'yield' keyword do in a Python function?", "Terminates the program", "Returns an iterator generator", "Imports an external module", "Handles an exception", 'B', "yield turns a function into a generator that produces values lazily."),
            ("Python", "Intermediate", "Which method adds an element to the end of a list in Python?", "push()", "add()", "append()", "insert()", 'C', "list.append(x) appends an item to the end of the list."),

            // JavaScript
            ("JavaScript", "Beginner", "Which keyword declares a block-scoped variable in modern JavaScript?", "var", "let", "define", "dim", 'B', "let and const create block-scoped variables in modern ECMAScript."),
            ("JavaScript", "Beginner", "What is the result of typeof null in JavaScript?", "\"null\"", "\"undefined\"", "\"object\"", "\"boolean\"", 'C', "In JavaScript, typeof null returns \"object\" due to a legacy design artifact."),
            ("JavaScript", "Beginner", "Which method converts a JSON string into a JavaScript object?", "JSON.parse()", "JSON.stringify()", "JSON.toObject()", "JSON.convert()", 'A', "JSON.parse() deserializes a valid JSON string into an object or value."),
            ("JavaScript", "Intermediate", "What does Promise.all() resolve to when all promises resolve?", "A single combined string", "An array of the resolved values", "The value of the quickest promise", "A boolean true", 'B', "Promise.all waits for all promises and resolves to an array of their results."),
            ("JavaScript", "Intermediate", "Which operator is used for strict equality comparison without type coercion?", "==", "===", "!=", "=>", 'B', "=== compares both value and type without converting types."),

            // HTML
            ("HTML", "Beginner", "Which element is used for the largest heading in standard HTML?", "<h6>", "<head>", "<h1>", "<header>", 'C', "<h1> represents the highest level page or section heading."),
            ("HTML", "Beginner", "Which tag is used to create a hyperlink?", "<link>", "<a>", "<href>", "<url>", 'B', "The <a> (anchor) element with href attribute creates a hyperlink."),
            ("HTML", "Beginner", "Which HTML attribute specifies an alternate text for an image?", "title", "caption", "alt", "src", 'C', "The alt attribute provides alternative text for accessibility and screen readers."),
            ("HTML", "Intermediate", "Which semantic HTML5 tag is appropriate for independent, self-contained content?", "<section>", "<article>", "<aside>", "<div>", 'B', "<article> represents a standalone composition in a document or site."),
            ("HTML", "Intermediate", "Which input type creates a dropdown selection menu in HTML?", "<select>", "<input type='dropdown'>", "<datalist>", "<option>", 'A', "<select> with nested <option> tags creates a dropdown menu."),

            // CSS
            ("CSS", "Beginner", "Which CSS property changes the text color of an element?", "font-style", "background", "color", "text-fill", 'C', "The color property sets the foreground text color."),
            ("CSS", "Beginner", "What does CSS stand for?", "Computer Style Sheets", "Creative Style System", "Cascading Style Sheets", "Colorful Style Sheets", 'C', "CSS stands for Cascading Style Sheets."),
            ("CSS", "Beginner", "How do you select an element with id='navbar' in CSS?", ".navbar", "#navbar", "*navbar", "@navbar", 'B', "The hash (#) symbol selects an element by its unique ID."),
            ("CSS", "Intermediate", "Which layout model is best suited for 1-dimensional row or column alignment?", "Float", "Table", "Flexbox", "Clearfix", 'C', "CSS Flexible Box Layout (Flexbox) is designed for 1-dimensional layouts."),
            ("CSS", "Intermediate", "Which property sets the space between the content and the border of an element?", "margin", "padding", "outline", "spacing", 'B', "Padding creates space inside the border, between border and content."),

            // Java
            ("Java", "Beginner", "Which method is the entry point of a standard Java console application?", "start()", "main()", "run()", "init()", 'B', "public static void main(String[] args) is standard entry point."),
            ("Java", "Beginner", "Which keyword is used to inherit a class in Java?", "implements", "inherits", "extends", "super", 'C', "A subclass uses extends to inherit from a superclass in Java."),
            ("Java", "Beginner", "Which primitive data type is used to store true/false values in Java?", "bit", "bool", "boolean", "Boolean", 'C', "The primitive boolean type stores either true or false."),
            ("Java", "Intermediate", "Which Java collection does not permit duplicate elements?", "ArrayList", "LinkedList", "HashSet", "Vector", 'C', "Set implementations like HashSet guarantee uniqueness of elements."),
            ("Java", "Intermediate", "What is the base class from which every class in Java inherits?", "System", "Class", "Object", "Root", 'C', "java.lang.Object is the root of the class hierarchy in Java."),

            // C++
            ("C++", "Beginner", "Which symbol ends most C++ statements?", ".", ":", ";", "!", 'C', "A semicolon terminates statements in C and C++."),
            ("C++", "Beginner", "Which operator is used to output data to the console with std::cout?", ">>", "<<", "->", "::", 'B', "The insertion operator << is used with std::cout."),
            ("C++", "Beginner", "Which keyword is used to dynamically allocate memory on the heap in C++?", "alloc", "malloc", "new", "create", 'C', "The new operator allocates memory on the heap and calls constructors."),
            ("C++", "Intermediate", "What is a pointer in C++?", "A copy of an object", "A variable holding the memory address of another variable", "A loop counter", "A function template", 'B', "A pointer holds the memory address where another value resides."),
            ("C++", "Intermediate", "Which concept allows a function or class to work with generic data types in C++?", "Templates", "Namespaces", "Pointers", "References", 'A', "C++ templates provide compile-time polymorphism for generic programming.")
        };

        foreach (var q in questions)
        {
            var existsSql = "SELECT COUNT(*) FROM dbo.Questions WHERE QuestionText=@qt AND Language=@lang";
            await using var checkCmd = new SqlCommand(existsSql, con);
            checkCmd.Parameters.AddWithValue("@qt", q.Q);
            checkCmd.Parameters.AddWithValue("@lang", q.Lang);
            var exists = Convert.ToInt32(await checkCmd.ExecuteScalarAsync()) > 0;

            if (!exists)
            {
                var insertSql = """
                    INSERT INTO dbo.Questions(CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
                    SELECT Id, @lang, @diff, @qt, @oa, @ob, @oc, @od, @co, @exp
                    FROM dbo.Categories WHERE Name=@lang;
                    """;
                await using var insCmd = new SqlCommand(insertSql, con);
                insCmd.Parameters.AddWithValue("@lang", q.Lang);
                insCmd.Parameters.AddWithValue("@diff", q.Diff);
                insCmd.Parameters.AddWithValue("@qt", q.Q);
                insCmd.Parameters.AddWithValue("@oa", q.A);
                insCmd.Parameters.AddWithValue("@ob", q.B);
                insCmd.Parameters.AddWithValue("@oc", q.C);
                insCmd.Parameters.AddWithValue("@od", q.D);
                insCmd.Parameters.AddWithValue("@co", q.Correct);
                insCmd.Parameters.AddWithValue("@exp", q.Exp);
                await insCmd.ExecuteNonQueryAsync();
            }
        }
    }
}
