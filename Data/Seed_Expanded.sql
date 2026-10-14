USE CodeQuest;
GO

-- ============================================================================
-- PYTHON QUESTIONS (11 to 20)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the is operator test in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'What does the is operator test in Python?', N'Value equality', N'Object identity (memory reference)', N'Substring presence', N'Type inheritance', 'B', N'is checks if both variables refer to the exact same object in memory; == tests value equality.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'How do you create an empty set in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'How do you create an empty set in Python?', N'{}', N'set()', N'[]', N'set{}', 'B', N'{} creates an empty dictionary; set() creates an empty set.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the output of ''Hello''[::-1] in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'What is the output of ''Hello''[::-1] in Python?', N'''Hello''', N'''olleH''', N'''H''', N'IndexError', 'B', N'The slice step -1 reverses the sequence.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword is used to raise an exception manually in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'Which keyword is used to raise an exception manually in Python?', N'throw', N'raise', N'catch', N'trigger', 'B', N'Python uses raise to throw exceptions.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the pass statement do in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Beginner', N'What does the pass statement do in Python?', N'Exits the loop', N'Skips to next iteration', N'Does nothing (null placeholder)', N'Returns None', 'C', N'pass is a null operation used where code is syntactically required.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is a lambda function in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What is a lambda function in Python?', N'A recursive function', N'A small anonymous inline function', N'A multi-threaded function', N'A deprecated construct', 'B', N'A lambda function is an anonymous function defined using the lambda keyword.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the purpose of the with statement in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What is the purpose of the with statement in Python?', N'Loop iteration', N'Automatic context management and resource cleanup', N'Class inheritance', N'Module aliasing', 'B', N'The with statement simplifies exception handling by encapsulating cleanup actions via context managers.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which decorator binds a method to the class rather than the instance in Python?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'Which decorator binds a method to the class rather than the instance in Python?', N'@staticmethod', N'@classmethod', N'@property', N'@instance', 'B', N'@classmethod passes the class cls as the first argument instead of self.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does zip([1, 2], [''a'', ''b'']) produce when converted to a list?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What does zip([1, 2], [''a'', ''b'']) produce when converted to a list?', N'[(1, ''a''), (2, ''b'')]', N'[1, 2, ''a'', ''b'']', N'[[1, 2], [''a'', ''b'']]', N'{1: ''a'', 2: ''b''}', 'A', N'zip() pairs corresponding elements from multiple iterables into tuples.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the GIL (Global Interpreter Lock) in CPython?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Python', N'Intermediate', N'What is the GIL (Global Interpreter Lock) in CPython?', N'A network firewall', N'A mutex preventing multiple native threads from executing bytecodes simultaneously', N'A memory leak tracker', N'An interpreter JIT cache', 'B', N'The GIL ensures thread safety by permitting only one native thread to execute Python bytecode at a time.'
	FROM dbo.Categories WHERE Name = N'Python';
END;

-- ============================================================================
-- JAVASCRIPT QUESTIONS (11 to 20)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which built-in method returns the keys of an object as an array?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'Which built-in method returns the keys of an object as an array?', N'Object.values()', N'Object.keys()', N'Object.entries()', N'Object.names()', 'B', N'Object.keys(obj) returns an array of an object''s own enumerable property names.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What will Boolean(0) evaluate to in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'What will Boolean(0) evaluate to in JavaScript?', N'true', N'false', N'undefined', N'null', 'B', N'0 is a falsy value in JavaScript.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'How can you convert the string ''42'' to a number in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'How can you convert the string ''42'' to a number in JavaScript?', N'Number(''42'')', N'parseInt(''42'')', N'+''42''', N'All of the above', 'D', N'All three approaches convert numeric strings to JavaScript numbers.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the push() method do to an array in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'What does the push() method do to an array in JavaScript?', N'Removes the last item', N'Appends elements to the end and returns new length', N'Reverses order', N'Sorts elements', 'B', N'push() appends one or more elements to the end of an array.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword immediately stops execution of a loop in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Beginner', N'Which keyword immediately stops execution of a loop in JavaScript?', N'continue', N'stop', N'break', N'exit', 'C', N'break immediately terminates the current enclosing loop.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the result of [1, 2] == [1, 2] in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What is the result of [1, 2] == [1, 2] in JavaScript?', N'true', N'false', N'TypeError', N'undefined', 'B', N'In JavaScript, distinct arrays have different references in memory, so comparison yields false.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the difference between let and const in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What is the difference between let and const in JavaScript?', N'const is function-scoped', N'const cannot be reassigned after declaration', N'const cannot hold objects', N'let is hoisted while const is not', 'B', N'const creates an immutable binding that cannot be reassigned.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the spread operator (...) do when used with an array?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What does the spread operator (...) do when used with an array?', N'Compresses array memory', N'Expands elements into individual arguments or elements', N'Converts array to binary', N'Freezes array values', 'B', N'Spread syntax expands iterables into places where zero or more elements are expected.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does setTimeout(fn, 0) do in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What does setTimeout(fn, 0) do in JavaScript?', N'Runs synchronously on current line', N'Queues execution to the macro-task queue after current call stack clears', N'Throws an error', N'Runs on a separate thread', 'B', N'Even at 0ms, setTimeout defers execution until the synchronous call stack is empty.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the purpose of Object.freeze() in JavaScript?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'JavaScript', N'Intermediate', N'What is the purpose of Object.freeze() in JavaScript?', N'Removes properties', N'Prevents property addition, modification, or deletion', N'Clones deeply', N'Converts object to string', 'B', N'Object.freeze() makes an object shallowly immutable.'
	FROM dbo.Categories WHERE Name = N'JavaScript';
END;

-- ============================================================================
-- HTML QUESTIONS (11 to 20)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which tag creates a single-line text input field in HTML?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which tag creates a single-line text input field in HTML?', N'<textfield>', N'<input type="text">', N'<text>', N'<entry>', 'B', N'<input type="text"> is the standard element for single-line text input.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which attribute opens a hyperlink in a new browser tab or window?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which attribute opens a hyperlink in a new browser tab or window?', N'target="_blank"', N'window="new"', N'href="_new"', N'open="tab"', 'A', N'target="_blank" tells the browser to open the linked document in a new window or tab.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which HTML tag is used to display tabular rows and columns?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which HTML tag is used to display tabular rows and columns?', N'<grid>', N'<table>', N'<data>', N'<sheet>', 'B', N'The <table> element represents tabular data formatted in rows and columns.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which element defines the webpage title displayed on the browser tab?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'Which element defines the webpage title displayed on the browser tab?', N'<meta>', N'<heading>', N'<title>', N'<header>', 'C', N'The <title> element inside <head> sets the title shown in the browser window title bar.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the <br> tag produce in HTML?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Beginner', N'What does the <br> tag produce in HTML?', N'A horizontal dividing line', N'A single line break', N'Bold text', N'A paragraph container', 'B', N'<br> inserts a line break without beginning a new paragraph.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the fundamental layout difference between <div> and <span>?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'What is the fundamental layout difference between <div> and <span>?', N'<div> is inline; <span> is block', N'<div> is a block-level element; <span> is an inline element', N'<span> is only for numbers', N'There is no difference', 'B', N'<div> starts on a new line and takes full width, while <span> stays within the text stream.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which semantic element best wraps an independent, self-contained article or blog post?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'Which semantic element best wraps an independent, self-contained article or blog post?', N'<section>', N'<aside>', N'<article>', N'<div>', 'C', N'<article> specifies independent, self-contained content.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which attribute in an HTML input field enforces a regular expression pattern?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'Which attribute in an HTML input field enforces a regular expression pattern?', N'regex', N'pattern', N'validate', N'match', 'B', N'The pattern attribute specifies a regex that the input value is checked against.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the purpose of the <datalist> element in HTML5?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'What is the purpose of the <datalist> element in HTML5?', N'Stores database rows', N'Provides an autocomplete dropdown list for an <input>', N'Styles list bullets', N'Preloads images', 'B', N'<datalist> contains predefined <option> values to suggest to users as they type.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which tag defines a thematic divider or horizontal rule in HTML?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'HTML', N'Intermediate', N'Which tag defines a thematic divider or horizontal rule in HTML?', N'<line>', N'<divider>', N'<hr>', N'<break>', 'C', N'<hr> creates a thematic break or horizontal separator between paragraph-level elements.'
	FROM dbo.Categories WHERE Name = N'HTML';
END;

-- ============================================================================
-- CSS QUESTIONS (11 to 20)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which CSS property makes text bold?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'Which CSS property makes text bold?', N'font-style', N'font-weight', N'text-decoration', N'font-bold', 'B', N'font-weight: bold (or 700) sets the visual weight/thickness of the font.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'How do you center text horizontally inside a block element in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'How do you center text horizontally inside a block element in CSS?', N'align: center', N'text-align: center', N'margin: center', N'horizontal-align: center', 'B', N'text-align: center aligns inline and text content within its parent block.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which CSS pseudo-class styles an element when hovered over with a mouse?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'Which CSS pseudo-class styles an element when hovered over with a mouse?', N':active', N':hover', N':focus', N':visited', 'B', N':hover applies styles when the user positions the pointer over an element.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which property hides an element while still reserving its space in the layout?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'Which property hides an element while still reserving its space in the layout?', N'display: none', N'visibility: hidden', N'opacity: 1', N'position: static', 'B', N'visibility: hidden hides the element without altering page layout geometry.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does CSS stand for?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Beginner', N'What does CSS stand for?', N'Creative Style Sheets', N'Cascading Style Sheets', N'Computer Style Sheets', N'Colorful Style Sheets', 'B', N'CSS stands for Cascading Style Sheets.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'In CSS Grid, which property defines the columns of the grid container?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'In CSS Grid, which property defines the columns of the grid container?', N'grid-template-columns', N'grid-column-gap', N'grid-auto-flow', N'column-count', 'A', N'grid-template-columns defines the line names and track sizing functions of grid columns.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is specificity in CSS?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'What is specificity in CSS?', N'How fast CSS compiles', N'The algorithm determining which CSS rule takes precedence when selectors conflict', N'The image resolution density', N'The sequence of CSS classes', 'B', N'Specificity determines which CSS rule is applied by the browser when multiple rules target the same element.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which CSS property enables smooth transitions between state changes?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'Which CSS property enables smooth transitions between state changes?', N'animation-fill-mode', N'transition', N'transform', N'interpolate', 'B', N'The transition property enables smooth interpolation of CSS property changes over time.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is an element with position: absolute positioned relative to?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'What is an element with position: absolute positioned relative to?', N'The browser viewport only', N'The nearest ancestor with position other than static', N'The next sibling', N'The parent flexbox container always', 'B', N'position: absolute positions relative to the nearest positioned ancestor (relative, absolute, fixed, or sticky).'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which media query feature checks if the operating system is in dark mode?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'CSS', N'Intermediate', N'Which media query feature checks if the operating system is in dark mode?', N'(theme: dark)', N'(prefers-color-scheme: dark)', N'(color-mode: dark)', N'(night-mode: true)', 'B', N'@media (prefers-color-scheme: dark) targets users who have expressed a preference for dark mode.'
	FROM dbo.Categories WHERE Name = N'CSS';
END;

-- ============================================================================
-- JAVA QUESTIONS (11 to 20)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which keyword instantiates a new object in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which keyword instantiates a new object in Java?', N'create', N'make', N'new', N'instance', 'C', N'new allocates heap memory for a new object and calls its constructor.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the direct or indirect superclass of all classes in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'What is the direct or indirect superclass of all classes in Java?', N'java.lang.System', N'java.lang.Object', N'java.lang.Class', N'java.lang.Root', 'B', N'Every class in Java descends from java.lang.Object.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which primitive type in Java stores a 16-bit Unicode character?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which primitive type in Java stores a 16-bit Unicode character?', N'byte', N'char', N'short', N'string', 'B', N'In Java, char is an unsigned 16-bit integral type storing Unicode characters.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which access modifier restricts visibility strictly to its own declaring class?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'Which access modifier restricts visibility strictly to its own declaring class?', N'public', N'protected', N'private', N'default', 'C', N'private restricts access strictly to the enclosing class.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the static keyword indicate on a method in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Beginner', N'What does the static keyword indicate on a method in Java?', N'Cannot be invoked', N'Belongs to the class itself rather than instances', N'Thread-synchronized', N'Executes at compile-time', 'B', N'static methods can be invoked directly on the class without creating an object.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the difference between == and .equals() for Strings in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'What is the difference between == and .equals() for Strings in Java?', N'No difference', N'== compares memory references; .equals() compares character values', N'== is case-insensitive', N'.equals() compares hashes only', 'B', N'== tests if both references point to the same memory location; .equals() tests value equality.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the primary benefit of the try-with-resources statement in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'What is the primary benefit of the try-with-resources statement in Java?', N'Faster performance', N'Automatic closing of AutoCloseable resources upon exit', N'Suppresses NullPointerExceptions', N'Enables parallel thread processing', 'B', N'try-with-resources guarantees that every declared resource is closed at the end of the statement.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which Java collection interface forbids duplicate elements?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'Which Java collection interface forbids duplicate elements?', N'List', N'Queue', N'Set', N'Vector', 'C', N'A Set is a collection that cannot contain duplicate elements.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What happens when a class implements an interface but omits method implementations?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'What happens when a class implements an interface but omits method implementations?', N'Compiler assigns dummy returns', N'The class must be declared abstract or compilation fails', N'Throws runtime errors', N'JVM provides default nulls', 'B', N'If a class implements an interface, it must either implement all abstract methods or be declared abstract.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does the volatile keyword guarantee for a variable in Java?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'Java', N'Intermediate', N'What does the volatile keyword guarantee for a variable in Java?', N'Makes it immutable', N'Guarantees memory visibility across threads directly from main memory', N'Encrypts value', N'Prevents garbage collection', 'B', N'volatile ensures that changes made by one thread are immediately visible to all other threads.'
	FROM dbo.Categories WHERE Name = N'Java';
END;

-- ============================================================================
-- C++ QUESTIONS (11 to 20)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which operator accesses struct or class members through a pointer in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which operator accesses struct or class members through a pointer in C++?', N'.', N'->', N'::', N'*', 'B', N'The arrow operator -> dereferences the pointer and accesses the member.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the scope resolution operator in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'What is the scope resolution operator in C++?', N'::', N'->', N'.', N':', 'A', N'The double colon :: operator resolves scope qualifiers (namespaces, classes, or globals).'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which standard container represents a dynamically sized contiguous array in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which standard container represents a dynamically sized contiguous array in C++?', N'std::list', N'std::vector', N'std::set', N'std::deque', 'B', N'std::vector stores elements in contiguous memory and grows automatically.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does std::endl do besides inserting a newline in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'What does std::endl do besides inserting a newline in C++?', N'Clears terminal screen', N'Flushes the output stream buffer', N'Pauses execution', N'Formats text to bold', 'B', N'std::endl outputs a newline character and forces a flush of the stream buffer.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'Which stream object is designated for unbuffered error output in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Beginner', N'Which stream object is designated for unbuffered error output in C++?', N'std::cin', N'std::cerr', N'std::clog', N'std::cout', 'B', N'std::cerr is tied to the standard error device and is unbuffered.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does a const qualifier at the end of a member function declaration mean in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What does a const qualifier at the end of a member function declaration mean in C++?', N'Returns a constant', N'Guarantees the function will not modify the member variables of the calling object', N'Prevents overriding', N'Inlines the function', 'B', N'A const member function promises not to modify any non-mutable member variables of the instance.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What defines an abstract class or interface in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What defines an abstract class or interface in C++?', N'The abstract keyword', N'At least one pure virtual function (virtual void f() = 0;)', N'Having no constructor', N'Declaring private inheritance', 'B', N'A class containing at least one pure virtual function is abstract and cannot be instantiated.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What does std::move() accomplish in modern C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What does std::move() accomplish in modern C++?', N'Copies memory bytes', N'Casts an expression to an rvalue reference to enable move semantics', N'Spawns a thread', N'Frees heap memory', 'B', N'std::move performs an unconditional cast to an rvalue reference, enabling resource transfer without copying.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the primary performance difference between std::map and std::unordered_map in C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What is the primary performance difference between std::map and std::unordered_map in C++?', N'std::map is a sorted Red-Black tree (O(log N)); std::unordered_map is a hash table (O(1) average)', N'std::unordered_map is always sorted', N'std::map only supports integer keys', N'There is no performance difference', 'A', N'std::map maintains ordering via binary search tree with O(log N) lookup; std::unordered_map uses hashing.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Questions WHERE QuestionText = N'What is the Rule of Five in modern C++?')
BEGIN
	INSERT INTO dbo.Questions (CategoryId, Language, Difficulty, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Explanation)
	SELECT Id, N'C++', N'Intermediate', N'What is the Rule of Five in modern C++?', N'A limit of 5 parameters', N'If a class defines any destructor or copy/move operations, it should explicitly define all five', N'Maximum 5 nested classes', N'Template recursion limit', 'B', N'The Rule of Five states that if a class defines a destructor, copy constructor, copy assignment, move constructor, or move assignment, all 5 should be declared.'
	FROM dbo.Categories WHERE Name = N'C++';
END;

GO
