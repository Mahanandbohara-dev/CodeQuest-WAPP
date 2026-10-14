USE CodeQuest;
GO

-- Seed Admin User (Password: Admin@123)
IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Username = N'admin' OR Email = N'admin@codequest.com')
BEGIN
	INSERT INTO dbo.Users
	(Username, Email, Address, Country, PasswordHash, PasswordSalt, Role, TotalScore, CurrentStreak)
	VALUES
	(N'admin', N'admin@codequest.com', N'Kathmandu, Bagmati', N'Nepal', 
	 N'e/q8jP5f3cZJb7vG7kGZ8v4zF2Yf9dE4tT2q1lP8xVo=', N'rL5sW8yQ1mK3vB7nP4tR6w==', 
	 N'Administrator', 250, 5);
END;

-- Seed Sample Learner (Password: User@123)
IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Username = N'prabit' OR Email = N'prabit@gmail.com')
BEGIN
	INSERT INTO dbo.Users
	(Username, Email, Address, Country, PasswordHash, PasswordSalt, Role, TotalScore, CurrentStreak)
	VALUES
	(N'prabit', N'prabit@gmail.com', N'Pepsicola, Kathmandu', N'Nepal', 
	 N'e/q8jP5f3cZJb7vG7kGZ8v4zF2Yf9dE4tT2q1lP8xVo=', N'rL5sW8yQ1mK3vB7nP4tR6w==', 
	 N'Learner', 120, 3);
END;

-- ============================================================================
-- 1. PYTHON QUESTIONS (10 questions: Beginner & Intermediate)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword defines a function in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'Which keyword defines a function in Python?', N'func', N'def', N'function', N'define', 'B', N'Python uses def to define a function.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which data type is immutable in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'Which data type is immutable in Python?', N'list', N'dict', N'set', N'tuple', 'D', N'Tuples cannot be modified after creation.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the yield keyword do in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What does the yield keyword do in Python?', N'Terminates execution', N'Returns a generator', N'Imports a package', N'Raises an error', 'B', N'yield creates generator functions that yield items lazily.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'How do you append an element to the end of a list in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'How do you append an element to the end of a list in Python?', N'add()', N'append()', N'push()', N'insert_last()', 'B', N'list.append(x) adds an item to the end of the list.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which built-in function returns the number of items in a list or string?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'Which built-in function returns the number of items in a list or string?', N'size()', N'count()', N'len()', N'length()', 'C', N'len() returns the length (the number of items) of an object.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the output of bool([]) in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'What is the output of bool([]) in Python?', N'True', N'False', N'None', N'TypeError', 'B', N'Empty sequences (lists, tuples, strings) evaluate to False in boolean contexts.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which method removes leading and trailing whitespaces from a string in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'Which method removes leading and trailing whitespaces from a string in Python?', N'strip()', N'trim()', N'clean()', N'slice()', 'A', N'str.strip() returns a copy of the string with leading and trailing characters removed.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the *args parameter allow in a Python function definition?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What does the *args parameter allow in a Python function definition?', N'Keyword arguments only', N'Variable number of positional arguments', N'Strict type checking', N'Parallel thread execution', 'B', N'*args packs positional arguments into a tuple passed into the function.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the primary role of the __init__ method in a Python class?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What is the primary role of the __init__ method in a Python class?', N'Deconstruct an instance', N'Initialize instance attributes upon creation', N'Override operator precedence', N'Compile module to bytecode', 'B', N'__init__ acts as the constructor method that initializes an instance.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does [x**2 for x in range(5) if x % 2 == 0] evaluate to?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What does [x**2 for x in range(5) if x % 2 == 0] evaluate to?', N'[0, 4, 16]', N'[1, 9]', N'[0, 1, 4, 9, 16]', N'[4, 16]', 'A', N'range(5) has even values 0, 2, 4. Their squares are 0, 4, and 16.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

-- ============================================================================
-- 2. JAVASCRIPT QUESTIONS (10 questions: Beginner & Intermediate)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword declares a block-scoped variable in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'Which keyword declares a block-scoped variable in JavaScript?', N'var', N'let', N'define', N'dim', 'B', N'let and const are block-scoped variable declarations introduced in ES6.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the result of typeof null in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'What is the result of typeof null in JavaScript?', N'"null"', N'"undefined"', N'"object"', N'"boolean"', 'C', N'typeof null returns "object" due to a legacy bug preserved for web compatibility.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which method parses a JSON string into a JavaScript object?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'Which method parses a JSON string into a JavaScript object?', N'JSON.stringify()', N'JSON.parse()', N'JSON.toObject()', N'JSON.cast()', 'B', N'JSON.parse() deserializes a JSON string into a JavaScript value or object.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which operator checks for both value and type equality without coercion?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'Which operator checks for both value and type equality without coercion?', N'==', N'===', N'=', N'!=', 'B', N'The strict equality operator === checks values without performing implicit type conversion.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does Array.prototype.map() return in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'What does Array.prototype.map() return in JavaScript?', N'The original array mutated', N'A new array with transformed elements', N'A single accumulated number', N'The index of the matched element', 'B', N'map() returns a brand new array containing results from calling the callback on each item.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the result of the expression 2 + "2" in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'What is the result of the expression 2 + "2" in JavaScript?', N'4', N'"22"', N'NaN', N'TypeError', 'B', N'The binary plus operator concatenates operands whenever one operand is a string.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which construct handles rejections and errors in async/await code?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'Which construct handles rejections and errors in async/await code?', N'try...catch', N'onError', N'rescue', N'defer', 'A', N'Standard try...catch blocks gracefully catch promise rejections when using await.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is a closure in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What is a closure in JavaScript?', N'A function bundled with its surrounding lexical environment', N'A command to terminate worker threads', N'An unhandled exception in event handlers', N'A frozen object that cannot be edited', 'A', N'A closure gives an inner function access to an outer function scope even after it executes.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What happens when one promise rejects inside Promise.all()?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What happens when one promise rejects inside Promise.all()?', N'Ignores the failure and returns others', N'Immediately rejects with that error', N'Retries the rejected operation', N'Returns null as result', 'B', N'Promise.all rejects immediately upon any input promise rejecting.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What describes the event bubbling phase in the DOM?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What describes the event bubbling phase in the DOM?', N'Events travel from window down to target', N'Events trigger on target and propagate upward to ancestors', N'Events loop indefinitely', N'Events cancel preventDefault()', 'B', N'During bubbling, an event triggers on the innermost element and travels up the DOM tree.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

-- ============================================================================
-- 3. HTML QUESTIONS (10 questions: Beginner & Intermediate)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which element is used for the largest heading in HTML?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which element is used for the largest heading in HTML?', N'<h6>', N'<head>', N'<h1>', N'<header>', 'C', N'<h1> designates the top-level, largest semantic heading.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which tag is used to create a hyperlink?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which tag is used to create a hyperlink?', N'<link>', N'<a>', N'<href>', N'<url>', 'B', N'The <a> anchor tag defines hyperlinks.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which attribute specifies alternate text for an image?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which attribute specifies alternate text for an image?', N'title', N'src', N'alt', N'desc', 'C', N'The alt attribute provides fallback text for accessibility and broken images.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which tag defines an unordered bulleted list in HTML?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which tag defines an unordered bulleted list in HTML?', N'<ol>', N'<ul>', N'<li>', N'<list>', 'B', N'<ul> defines an unordered list; <ol> defines an ordered list.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which element is used to play video files natively in HTML5?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which element is used to play video files natively in HTML5?', N'<media>', N'<movie>', N'<video>', N'<player>', 'C', N'HTML5 introduced the standard <video> element for video playback.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which tag is used to create a dropdown selection list in an HTML form?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which tag is used to create a dropdown selection list in an HTML form?', N'<input type="dropdown">', N'<select>', N'<listbox>', N'<combobox>', 'B', N'<select> paired with <option> elements creates a drop-down menu.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the semantic element <nav> represent?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'What does the semantic element <nav> represent?', N'A section containing navigational links', N'The browser navigation toolbar', N'A pop-up modal header', N'A sidebar advertisement block', 'A', N'<nav> is designated for major navigation links on a website.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the purpose of the viewport meta tag in HTML?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'What is the purpose of the viewport meta tag in HTML?', N'Disables user zooming', N'Configures mobile screen scaling and responsive sizing', N'Preloads Google fonts', N'Enables desktop fullscreen mode', 'B', N'The viewport meta tag instructs browsers how to control the page dimensions and scaling.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the standard doctype declaration for modern HTML5 documents?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'What is the standard doctype declaration for modern HTML5 documents?', N'<!DOCTYPE html>', N'<!DOCTYPE HTML5 PUBLIC>', N'<html doctype="5">', N'<?doctype html5>', 'A', N'<!DOCTYPE html> is the concise and standard doctype for HTML5.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which attribute marks an input field as mandatory before form submission?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'Which attribute marks an input field as mandatory before form submission?', N'validate', N'mandatory', N'required', N'needed', 'C', N'The required attribute specifies that the user must fill out a value before submitting.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

-- ============================================================================
-- 4. CSS QUESTIONS (10 questions: Beginner & Intermediate)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which property changes text color in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'Which property changes text color in CSS?', N'font-style', N'background', N'color', N'text-fill', 'C', N'The color property sets the foreground color of text.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which layout model is best suited for 1-dimensional layouts in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'Which layout model is best suited for 1-dimensional layouts in CSS?', N'Float', N'Flexbox', N'Grid', N'Table', 'B', N'Flexbox is optimized for 1D row or column distribution, whereas Grid handles 2D.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'How do you select an element with id="main-header" in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'How do you select an element with id="main-header" in CSS?', N'.main-header', N'#main-header', N'*main-header', N'header[id]', 'B', N'The hash symbol (#) selects elements by their unique ID attribute.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which CSS property creates space outside of an element border?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'Which CSS property creates space outside of an element border?', N'padding', N'margin', N'spacing', N'outline', 'B', N'margin creates space outside borders; padding creates space inside borders.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the default value of the position property in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'What is the default value of the position property in CSS?', N'relative', N'absolute', N'static', N'fixed', 'C', N'Elements have position: static by default in regular document layout flow.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which CSS property modifies the size of font characters?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'Which CSS property modifies the size of font characters?', N'text-size', N'font-size', N'font-style', N'text-weight', 'B', N'font-size sets the rendering size of font characters.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'In CSS Flexbox, which property aligns items along the cross axis?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'In CSS Flexbox, which property aligns items along the cross axis?', N'justify-content', N'align-items', N'flex-direction', N'flex-flow', 'B', N'align-items aligns flex items along the cross axis; justify-content aligns along the main axis.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the z-index property control in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'What does the z-index property control in CSS?', N'Element opacity level', N'Zoom magnification', N'Stacking order of positioned elements', N'3D tilt angle', 'C', N'z-index controls vertical stacking order of positioned elements along the z-axis.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which CSS unit is relative to the font-size of the root <html> element?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'Which CSS unit is relative to the font-size of the root <html> element?', N'em', N'rem', N'vh', N'px', 'B', N'rem (Root EM) scales proportionally to the root element font-size.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the effect of setting box-sizing: border-box in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'What is the effect of setting box-sizing: border-box in CSS?', N'Adds border outside total width', N'Includes padding and border within the element declared width/height', N'Hides element borders completely', N'Rounds all element corners', 'B', N'border-box tells browsers to account for padding and border in the specified width and height.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

-- ============================================================================
-- 5. JAVA QUESTIONS (10 questions: Beginner & Intermediate)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which method is the entry point of a standard Java application?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which method is the entry point of a standard Java application?', N'start()', N'main()', N'run()', N'init()', 'B', N'public static void main(String[] args) is the standard Java entry point.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword is used to inherit a class in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which keyword is used to inherit a class in Java?', N'implements', N'extends', N'inherits', N'super', 'B', N'Java classes use extends for class inheritance and implements for interfaces.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the default value of a boolean field in a Java class?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'What is the default value of a boolean field in a Java class?', N'true', N'false', N'null', N'0', 'B', N'Uninitialized primitive boolean member variables default to false.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which Java collection maintains insertion order and allows duplicates?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which Java collection maintains insertion order and allows duplicates?', N'HashSet', N'ArrayList', N'TreeSet', N'HashMap', 'B', N'ArrayList preserves element insertion order and allows duplicate entries.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword prevents a Java class from being subclassed?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which keyword prevents a Java class from being subclassed?', N'static', N'abstract', N'final', N'sealed_only', 'C', N'A final class cannot be extended by any other class in Java.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the memory size of an int primitive type in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'What is the memory size of an int primitive type in Java?', N'16 bits', N'32 bits', N'64 bits', N'8 bits', 'B', N'In Java, int is always a signed 32-bit two''s complement integer.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the key difference between StringBuffer and StringBuilder?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'What is the key difference between StringBuffer and StringBuilder?', N'StringBuilder is thread-safe', N'StringBuffer is synchronized (thread-safe); StringBuilder is not', N'StringBuffer is immutable', N'StringBuilder only stores ASCII', 'B', N'StringBuffer methods are synchronized for multi-thread safety, making StringBuilder faster in single threads.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which unchecked exception is thrown when dereferencing a null reference in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'Which unchecked exception is thrown when dereferencing a null reference in Java?', N'IllegalArgumentException', N'NullPointerException', N'ClassCastException', N'NoSuchMethodException', 'B', N'NullPointerException is thrown when an application attempts to use null where an object is required.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the role of the JVM Garbage Collector?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'What is the role of the JVM Garbage Collector?', N'Transforms bytecode to binary', N'Reclaims heap memory from unreachable objects', N'Optimizes network I/O packets', N'Enforces encapsulation modifiers', 'B', N'The Garbage Collector automatically finds and frees heap space of objects no longer referenced.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which interface must a class implement to define its natural sort order?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'Which interface must a class implement to define its natural sort order?', N'Serializable', N'Comparable', N'Cloneable', N'Iterable', 'B', N'Comparable<T> requires defining compareTo(T o) for natural sorting.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

-- ============================================================================
-- 6. C++ QUESTIONS (10 questions: Beginner & Intermediate)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which symbol ends most C++ statements?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which symbol ends most C++ statements?', N'.', N':', N';', N'!', 'C', N'A semicolon terminates most C++ statements.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which operator allocates dynamic heap memory in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which operator allocates dynamic heap memory in C++?', N'malloc', N'new', N'alloc', N'create', 'B', N'new dynamically allocates memory on the heap and invokes constructors.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which operator deallocates memory allocated with new[] in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which operator deallocates memory allocated with new[] in C++?', N'delete', N'delete[]', N'free()', N'release', 'B', N'Memory allocated using array new[] must be freed using delete[].'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which header file is required to use std::cout and std::cin in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which header file is required to use std::cout and std::cin in C++?', N'<stdio.h>', N'<iostream>', N'<stream>', N'<conio.h>', 'B', N'<iostream> provides standard stream objects including std::cin and std::cout.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is a reference in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'What is a reference in C++?', N'A copy of a variable', N'An alias for an existing variable', N'A pointer to heap memory', N'A constant integer literal', 'B', N'A reference is an alias that shares the memory address of an existing variable.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword introduces generic programming and blueprints in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'Which keyword introduces generic programming and blueprints in C++?', N'generic', N'template', N'typename_only', N'prototype', 'B', N'template <typename T> defines generic class and function templates.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Why should a polymorphic base class declare a virtual destructor?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'Why should a polymorphic base class declare a virtual destructor?', N'To make constructor private', N'To ensure derived class destructors run when deleted via base pointer', N'To stop object copying', N'To trigger garbage collection', 'B', N'A virtual destructor guarantees complete cleanup of derived objects deleted via base pointers.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What core principle does RAII represent in modern C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What core principle does RAII represent in modern C++?', N'Runtime Array Index Inspection', N'Resource Acquisition Is Initialization (binding resource lifecycle to object lifetime)', N'Recursive Algorithm Iteration Index', N'Remote Asynchronous Invocation Interface', 'B', N'RAII binds resource allocation to constructors and resource release to destructors.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which smart pointer provides exclusive ownership of a dynamically allocated object?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'Which smart pointer provides exclusive ownership of a dynamically allocated object?', N'std::shared_ptr', N'std::unique_ptr', N'std::weak_ptr', N'std::auto_ptr', 'B', N'std::unique_ptr cannot be copied and enforces exclusive ownership of the managed pointer.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the average time complexity of element lookup in std::unordered_map?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What is the average time complexity of element lookup in std::unordered_map?', N'O(N)', N'O(log N)', N'O(1)', N'O(N log N)', 'C', N'std::unordered_map uses a hash table providing constant O(1) average lookup time.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

GO