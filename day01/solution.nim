import std / strutils
import print

func parse(text: string): int =
  var onlyDigits: string
  for c in text:
    if c in '0' .. '9':
      onlyDigits.add c
  let
    first = onlyDigits[0]
    last = onlyDigits[^1]
  (ord(first) - ord('0'))*10 + (ord(last) - ord('0'))

var
  part1 = 0
  part2 = 0
for line in lines "input.txt":
  part1 += parse(line)
  let processLine = line.multiReplace([
    ("zero", "0"),
    ("one", "1"),
    ("two", "2"),
    ("three", "3"),
    ("four", "4"),
    ("five", "5"),
    ("six", "6"),
    ("seven", "7"),
    ("eight", "8"),
    ("nine", "9"),
  ])
  part2 += parse(processLine)
print part1
print part2