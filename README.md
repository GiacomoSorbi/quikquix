# QuikQuix App

## Description

WebApp to create and manage technical quizzes.

User will be able to:

- create, store and retrieve their own `Quiz` objects (see below) - **MVP**
- edit `Quiz` objects
- search for other users `Quiz`zes, (by tag, author, description, etc)
- group them into `Collection`s - **MVP**
- edit `Collection`s settings (score computation, time for each single text, etc)
- generate `Event`s in which the `Collection` becomes available to player via an unique PIN - **MVP**
- show stats about `Quiz`zes, `Collection`s and `Event`s (number of players involved, number of correct answers, etc)
- report `Quiz` objects

`Quiz` object format considered will always have:

- `title` - **MVP**
- `author` (userID)
- `created` (creation time)
- `stats` (how many times it has been visualised, how many correct answers it received)
- `tags` (#JS, #JavaScript, #Algorithms, etc) from a preset list, at least one is mandatory - **MVP**
- `defaultTime` - **MVP**
- `body`:
  - text only - **MVP**
  - text and images
  - `answers` (only for `select`, `multi`) - **MVP**
  - `answer` - **MVP**
- `type`:
  - `select` - multiple options (only one answer correct) - **MVP**
  - `multi` - multiple choices (multiple answers correct)
  - `text` - free typing
  - `order` - drag and drop to reorder codebits
