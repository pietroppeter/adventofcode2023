# advent of code 2023 in gleam

I am starting really from scratch, up to now I have only done some gelam exercise in exercism.

## detailed notes: day01

minimal setup:
- I created a project with `gleam new gl` (gleam is a reserved keyword so `gleam new gleam` would not work)
- removed the github CI and test folder
- running single files with main with `gleam run -m day01`

reading a file:
- there is nothing in the stdlib to read files because gleam runs places where there's no filesystem and js and erlang have different concurrency models that can't be unified
- reaching out to `simplifile` with `gleam add simplifile` (makes some assumptions that would be too bold for stdlib but fine for a package)
- forgot gleam uses snake case convention, compiler complains when trying to use `readInput` as name for function and gently suggests `read_input`

now I actually want to add back tests, I will work in a test driven way with the test inputs that aoc provides
- added back a test by copying and pasting from a new test project
- noticed that the default gleeunit template does not show how to import from my project in the test file (`import gl/day01` does not work and I should use `import day01`)
-  I will need to understand if I can ask to run only specific test, not a priority now

now working on part1:
- noticed that name of type `String` is not mentioned in Language Tour (could have been `Str` like I have `Int` and not `Integer`)