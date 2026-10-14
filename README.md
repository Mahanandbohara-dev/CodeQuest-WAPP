# 🚀 CodeQuest – Interactive Programming Learning Platform

[![.NET Version](https://img.shields.io/badge/.NET-10.0-purple.svg)](https://dotnet.microsoft.com/)
[![Language](https://img.shields.io/badge/Language-C%23-blue.svg)](https://docs.microsoft.com/en-us/dotnet/csharp/)
[![Framework](https://img.shields.io/badge/Framework-ASP.NET%20Core%20MVC-blueviolet.svg)](https://dotnet.microsoft.com/apps/aspnet)
[![Database](https://img.shields.io/badge/Database-SQL%20Server%20LocalDB-red.svg)](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/sql-server-express-localdb)
[![AI Integration](https://img.shields.io/badge/AI-Anthropic%20Claude-orange.svg)](https://www.anthropic.com/)

**CodeQuest** is a database-driven, gamified web platform designed to help learners master programming concepts across multiple languages through interactive quizzes, habit-forming streaks, achievement badges, relaxing mini-games, and AI tutoring hints.

---

## 📋 Table of Contents
1. [Project Overview](#-project-overview)
2. [Technology Stack](#-technology-stack)
3. [Key Features](#-key-features)
4. [System Architecture & Security](#-system-architecture--security)
5. [Database Design & Schema](#-database-design--schema)
6. [Getting Started & Setup](#-getting-started--setup)
7. [Default Demo Accounts](#-default-demo-accounts)
8. [Configuration Guide](#-configuration-guide)
9. [Project Proposal Alignment & Architecture Notes](#-project-proposal-alignment--architecture-notes)

---

## 🎯 Project Overview

CodeQuest addresses the common challenges in introductory programming education: high dropout rates, syntax frustration, and lack of engaging practice tools. By pairing timed, targeted quizzes with a gamified progression system and an on-demand AI tutor, CodeQuest transforms repetitive exercises into an engaging daily learning routine.

---

## 💻 Technology Stack

* **Backend Framework:** ASP.NET Core (.NET 10) MVC architecture
* **Language:** C# 13
* **Data Access:** High-performance ADO.NET (`Microsoft.Data.SqlClient`) with strict parameterized queries
* **Database Engine:** Microsoft SQL Server LocalDB (`(localdb)\MSSQLLocalDB`)
* **AI Tutor:** Anthropic Claude API (`claude-3-5-sonnet-20241022`) via HTTP client (with intelligent offline heuristic fallback)
* **Frontend:** Razor Pages / Views, HTML5, CSS3 (custom responsive dark-mode UI)
* **Client-Side Libraries:** jQuery 3.7.1, jQuery Validation 1.20.0, jQuery Validation Unobtrusive 4.0.0
* **Cryptography:** PBKDF2 (Rfc2898DeriveBytes) with HMAC-SHA256, 100,000 iterations, and cryptographic salt generation

---

## ✨ Key Features

### 1. 🛡️ Role-Based Authentication & Registration
* **Account Types:** Users can register as either a **Learner** (default) or an **Administrator**.
* **Admin Passcode Authorization:** Registering as an Administrator requires entering an **Admin Security Passcode** (default: `admin123`).
* **Cryptographic Security:** Passwords are never stored in plaintext; they are securely salted and hashed using PBKDF2 with SHA-256.
* **Role Redirection:** Administrators automatically land on the Management Console upon login, while Learners land on their personalized dashboard.

### 2. 👤 Learner Dashboard & Profile Self-Editing
* **Personalized Hub:** Displays real-time stats including current streak, total points accumulated, unlocked badges, and recent quiz sessions.
* **Profile Management:** Learners can self-edit their email address, physical location/city, and country with real-time validation and duplicate email prevention.
* **Habit Retention Tips:** Contextual daily advice to encourage regular practice habits.

### 3. 🎮 Brain Breaks & Relaxing Mini-Games
A dedicated relaxation zone for learners to unwind between intense coding sessions:
* **Code Memory Match (4x4 Grid):** Flip cards to match programming languages and tools (`Python`, `JavaScript`, `Java`, `C++`, `HTML`, `CSS`, `SQL`, `Git`). Tracks move count, matches found, and completion time.
* **Sliding 8-Tile Puzzle (3x3 Grid):** Classic sliding puzzle featuring guaranteed-solvable random shuffles, move tracking, and automated victory detection.
* **Seamless Tab Navigation:** Smoothly toggle between games without leaving the dashboard.

### 4. ⚡ Multi-Language Timed Quizzes
* **6 Major Languages:** Python, JavaScript, Java, C++, HTML, and CSS.
* **Rich Question Pool:** 60+ categorized questions with balanced **Beginner** and **Intermediate** difficulty levels.
* **Timed Sessions:** 5 randomized questions per quiz round with live countdown timers.
* **Instant Explanations:** Explanations accompany each question upon completion to reinforce why an answer is correct.
* **Attempt Persistence:** Full telemetry of scores, chosen options, and timestamps are recorded in the relational database.

### 5. 🤖 AI Tutor Hints (Anthropic Claude API)
* **Real AI Assistance:** Integrated with Anthropic Claude API (`/Ai/Ask`), delivering contextual, pedagogical hints to learners without spoiling the multiple-choice answer letter.
* **In-Code & Config Key Placement:** Place your API key directly in `Controllers/AiController.cs` or in `appsettings.json`.
* **Marker-Safe Offline Fallback:** If no API key is supplied or internet is disconnected, the assistant automatically switches to intelligent heuristic hints, ensuring the project never crashes or fails during marking.

### 6. 🏅 Gamification & Badge Automation
* **Streak Tracking:** Maintains daily continuous activity streaks to foster regular coding habits.
* **Score Economy:** Awards points for correct quiz submissions.
* **Automated Badges:** Dynamically unlocks achievements based on milestones:
  * **First Quest 🎯:** Completed the very first quiz session.
  * **High Scorer ⭐:** Scored 100% on any quiz round.
  * **Code Master 👑:** Accumulated 100+ total points.
  * **Topic Explorer 🧭:** Attempted quizzes across 3 or more distinct programming topics.

### 7. 🏆 Community Leaderboard
* Real-time global rankings showcasing top learners.
* Top 3 podium highlight with badges earned, total points, and continuous streaks.

### 8. ⚙️ Administrator Management Console
* **Platform Metrics:** Instant overview of total registered users, question count, categories, and quiz telemetry.
* **User Management:** View registered users, roles, countries, and manage administrative privileges.
* **Question Bank Oversight:** View, add, edit, and delete questions directly in the database.
* **Category Control:** Manage programming language categories.

---

## 🏛️ System Architecture & Security

* **Architecture Pattern:** Standard Model-View-Controller (MVC) separating presentation, controller routing, and data models.
* **SQL Injection Defense:** All queries against the database use strict parameterized commands (`SqlCommand.Parameters.AddWithValue` / explicit `SqlDbType` binding); zero dynamic SQL string concatenation.
* **Cross-Site Request Forgery (CSRF):** Protected via `@Html.AntiForgeryToken()` and `[ValidateAntiForgeryToken]` attributes on all state-altering POST endpoints.
* **Client-Side Validation:** Form inputs validate instantly using jQuery Unobtrusive Validation before submitting to the server.
* **Graceful Database Resilience:** Handled SQL exception filters (`SqlException.Number` 2601/2627 for duplicate keys) display user-friendly toast notifications instead of crashing.
* **Automated Database Bootstrapping:** `DbInitializer.cs` verifies database existence, provisions missing tables, and seeds initial data automatically upon app startup.

---

## 🗄️ Database Design & Schema

The database utilizes **Microsoft SQL Server LocalDB** with the following normalized relational schema:

```
[Users]
  ├── Id (PK, INT IDENTITY)
  ├── Username (NVARCHAR(100), UNIQUE)
  ├── Email (NVARCHAR(255), UNIQUE)
  ├── Address (NVARCHAR(255))
  ├── Country (NVARCHAR(100))
  ├── PasswordHash (NVARCHAR(255))
  ├── PasswordSalt (NVARCHAR(255))
  ├── Role (NVARCHAR(20) - 'Learner' | 'Administrator')
  ├── TotalScore (INT)
  ├── CurrentStreak (INT)
  └── CreatedAt (DATETIME2)

[Categories]
  ├── Id (PK, INT IDENTITY)
  └── Name (NVARCHAR(100), UNIQUE)

[Questions]
  ├── Id (PK, INT IDENTITY)
  ├── CategoryId (FK -> Categories.Id)
  ├── Language (NVARCHAR(50))
  ├── Difficulty (NVARCHAR(20) - 'Beginner' | 'Intermediate')
  ├── QuestionText (NVARCHAR(MAX))
  ├── OptionA, OptionB, OptionC, OptionD (NVARCHAR(500))
  ├── CorrectOption (CHAR(1) - 'A'|'B'|'C'|'D')
  └── Explanation (NVARCHAR(MAX))

[QuizAttempts]
  ├── Id (PK, INT IDENTITY)
  ├── UserId (FK -> Users.Id)
  ├── Score (INT)
  ├── TotalQuestions (INT)
  └── AttemptedAt (DATETIME2)

[AttemptDetails]
  ├── Id (PK, INT IDENTITY)
  ├── AttemptId (FK -> QuizAttempts.Id)
  ├── QuestionId (FK -> Questions.Id)
  ├── SelectedOption (CHAR(1))
  └── IsCorrect (BIT)

[Badges]
  ├── Id (PK, INT IDENTITY)
  ├── Name (NVARCHAR(100), UNIQUE)
  ├── Description (NVARCHAR(255))
  └── Icon (NVARCHAR(20))

[UserBadges] (Junction)
  ├── Id (PK, INT IDENTITY)
  ├── UserId (FK -> Users.Id)
  ├── BadgeId (FK -> Badges.Id)
  └── EarnedAt (DATETIME2)
```

---

## 🚀 Getting Started & Setup

### Prerequisites
1. **Operating System:** Windows 10/11
2. **SDK:** [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0) (or Visual Studio 2022/2026)
3. **Database:** SQL Server LocalDB (installed automatically with Visual Studio's *ASP.NET and web development* workload)

### Option A: Run from Visual Studio
1. Open Visual Studio.
2. Click **Open a project or solution** and select `CodeQuest.csproj`.
3. Press **F5** (or **Ctrl+F5**) to build and run.
4. The application will start and automatically bootstrap the database and seed questions!

### Option B: Run from Command Line
```bash
# Navigate to the project root
cd C:\Users\HP\Downloads\CodeQuest_Visual_Studio_CSharp\CodeQuest_Visual_Studio_CSharp

# Build and verify
dotnet build

# Run the web server
dotnet run
```
Open your browser and navigate to `http://localhost:5000` (or the URL indicated in the terminal).

---

## 🔑 Default Demo Accounts

For immediate testing, the database includes two pre-seeded accounts:

| Role | Username | Email | Password | Access Level |
| :--- | :--- | :--- | :--- | :--- |
| **Administrator** | `admin` | `admin@codequest.com` | `Admin@123` | Full Management Console (`/Admin`) |
| **Learner** | `prabit` | `prabit@gmail.com` | `User@123` | Learner Dashboard, Quizzes, Games |

*(You can also register new Learner or Administrator accounts at any time via `/Account/Register`)*.

---

## ⚙️ Configuration Guide

All configuration settings are centralized in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=CodeQuest;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True;"
  },
  "Anthropic": {
    "ApiKey": "PASTE_YOUR_CLAUDE_API_KEY_HERE",
    "Model": "claude-3-5-sonnet-20241022"
  },
  "AdminSecurity": {
    "SecretKey": "admin123"
  }
}
```

* **Claude API Key:** Can be set in `appsettings.json` under `"Anthropic:ApiKey"` OR in `Controllers/AiController.cs` on line 16 (`ClaudeApiKeyPlaceholder`).
* **Admin Registration Key:** The secret passcode required to register an Administrator account (default: `admin123`).

---

## 📝 Project Proposal Alignment & Architecture Notes

### Architectural Decision: SQL Server LocalDB vs. MySQL
* **Native ASP.NET Integration:** Microsoft SQL Server LocalDB was selected over MySQL to leverage native, zero-latency ADO.NET execution through `Microsoft.Data.SqlClient`.
* **Zero-Configuration Evaluation:** LocalDB runs as an in-process Windows developer database, eliminating the requirement for examiners or team members to configure external MySQL services or Docker daemons.
* **Full ACID Compliance:** Guarantees strict relational integrity for cascading attempt logs, user badges, and concurrency safety.

### AI Assistant Implementation
* The AI Assistant is integrated directly with the **Anthropic Claude API** (`claude-3-5-sonnet-20241022`).
* A pedagogical system prompt ensures that the AI guides the student's problem-solving process rather than directly revealing multiple-choice letters.
* An offline heuristic fallback guarantees that grading and local demonstrations run flawlessly without network dependencies or third-party quota constraints.

---

## 📄 License & Academic Attribution
Developed for the **CodeQuest Group Assignment** coursework. Built with modern ASP.NET Core MVC and C#. All rights reserved.
