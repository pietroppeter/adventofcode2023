import batteries, print

let example = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"""

func parseOasis(text: string): seq[seq[int]] =
  text.strip.splitLines.toSeq.mapIt(it.split.map(x => parseInt x))

print example.parseOasis

func diff(s: seq[int]): seq[int] =
  for i in 1 .. s.high:
    result.add s[i] - s[i - 1]

func allDiffs(s: seq[int]): seq[seq[int]] =
  result.add s
  while not result[^1].allIt(it == 0):
    result.add result[^1].diff

for s in example.parseOasis:
  print s.allDiffs

func predict(diffs: seq[seq[int]]): int =
  for i in countdown(diffs.high - 1, 0):
    result = result + diffs[i][^1]

for s in example.parseOasis:
  print s.allDiffs.predict

func part1(oasis: seq[seq[int]]): int =
  for diffs in oasis.mapIt(allDiffs it):
    result.inc predict diffs

print part1 example.parseOasis
print part1 "puzzle.txt".readFile.parseOasis

func predictBack(diffs: seq[seq[int]]): int =
  for i in countdown(diffs.high - 1, 0):
    result = diffs[i][0] - result

func part2(oasis: seq[seq[int]]): int =
  for diffs in oasis.mapIt(allDiffs it):
    result.inc predictBack diffs

print part2 example.parseOasis
print part2 "puzzle.txt".readFile.parseOasis
