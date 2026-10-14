IF DB_ID(N'CodeQuest') IS NULL
BEGIN
	CREATE DATABASE CodeQuest;
END;
GO

USE CodeQuest;
GO

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
GO

-- Add missing columns if upgrading an existing Users table
IF COL_LENGTH(N'dbo.Users', N'Address') IS NULL
    ALTER TABLE dbo.Users ADD Address NVARCHAR(255) NULL;
GO
IF COL_LENGTH(N'dbo.Users', N'Country') IS NULL
    ALTER TABLE dbo.Users ADD Country NVARCHAR(100) NULL;
GO
IF COL_LENGTH(N'dbo.Users', N'PasswordSalt') IS NULL
    ALTER TABLE dbo.Users ADD PasswordSalt NVARCHAR(255) NULL;
GO
IF COL_LENGTH(N'dbo.Users', N'CreatedAt') IS NULL
    ALTER TABLE dbo.Users ADD CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME();
GO


IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Categories (
		Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
		Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_Categories_Name UNIQUE
	);
END;
GO

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
		CONSTRAINT CK_Questions_Difficulty CHECK (Difficulty IN (N'Beginner', N'Intermediate')),
		CONSTRAINT CK_Questions_CorrectOption CHECK (CorrectOption IN ('A', 'B', 'C', 'D')),
		CONSTRAINT FK_Questions_Categories FOREIGN KEY (CategoryId)
			REFERENCES dbo.Categories(Id) ON DELETE SET NULL
	);
END;
GO

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
GO

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
GO

IF OBJECT_ID(N'dbo.Badges', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Badges (
		Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Badges PRIMARY KEY,
		Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_Badges_Name UNIQUE,
		Description NVARCHAR(255) NOT NULL
	);
END;
GO

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
GO

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
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = N'Python') INSERT INTO dbo.Categories(Name) VALUES (N'Python');
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = N'JavaScript') INSERT INTO dbo.Categories(Name) VALUES (N'JavaScript');
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = N'Java') INSERT INTO dbo.Categories(Name) VALUES (N'Java');
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = N'C++') INSERT INTO dbo.Categories(Name) VALUES (N'C++');
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = N'HTML') INSERT INTO dbo.Categories(Name) VALUES (N'HTML');
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = N'CSS') INSERT INTO dbo.Categories(Name) VALUES (N'CSS');

IF NOT EXISTS (SELECT 1 FROM dbo.Badges WHERE Name = N'First Quest') INSERT INTO dbo.Badges(Name, Description) VALUES (N'First Quest', N'Complete your first quiz.');
IF NOT EXISTS (SELECT 1 FROM dbo.Badges WHERE Name = N'7 Day Streak') INSERT INTO dbo.Badges(Name, Description) VALUES (N'7 Day Streak', N'Maintain a seven-day learning streak.');
IF NOT EXISTS (SELECT 1 FROM dbo.Badges WHERE Name = N'Perfect Score') INSERT INTO dbo.Badges(Name, Description) VALUES (N'Perfect Score', N'Score 100%.');
IF NOT EXISTS (SELECT 1 FROM dbo.Badges WHERE Name = N'Topic Explorer') INSERT INTO dbo.Badges(Name, Description) VALUES (N'Topic Explorer', N'Complete quizzes from multiple topics.');
GO