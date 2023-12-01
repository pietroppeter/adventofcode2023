import std / strutils
import print

func parse(text: string): int =
  var onlyDigits: string
  for c in text:
    if c in '0' .. '9':
      onlyDigits.add c
  if onlyDigits.len == 0:
    return 0
  let
    first = onlyDigits[0]
    last = onlyDigits[^1]
  (ord(first) - ord('0'))*10 + (ord(last) - ord('0'))

let testInput2 = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"""

var
  part1 = 0
  part2 = 0
#for line in testInput2.splitLines:
for line in lines "input.txt":
  print line
  part1 += parse(line)
  let processedLine = line.replace("t", "tt").replace("on", "oon").replace("ei", "eei").multiReplace([
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
  print processedLine
  part2 += parse(processedLine)
print part1
print part2