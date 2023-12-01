# advent of code 2023 in gleam

I am starting really from scratch, up to now I have only done some gelam exercise in exercism.

minimal setup:
- I created a project with `gleam new gl` (gleam is a reserved keyword so `gleam new gleam` would not work)
- removed the github CI and test folder
- running single files with main with `gleam run -m day01`

reading a file:
- there is nothing in the stdlib to read files because gleam runs places where there's no filesystem and js and erlang have different concurrency models that can't be unified
- reaching out to `simplifile` with `gleam add simplifile`
- forgot gleam uses snake case convention, compiler complains when trying to use `readInput` as name for function and gently suggests `read_input`