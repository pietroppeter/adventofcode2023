import batteries, print

let example1 = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."""

type
  Point = tuple[x, y: int]
  Map = seq[Point]

func parseMap(text: string): Map =
  var
    x = 0
    y = 0
  for c in text.strip:
    if c == '\n':
      inc y
      x = 0
    elif c == '#':
      result.add (x, y)
      inc x
    else:
      inc x

let map1 = example1.parseMap
print map1
print map1.len

func zeroCounts(t: CountTable[int]): seq[int] =
  for n in 0 ..< t.keys.toSeq.max:
    if t[n] == 0:
      result.add n

func zeroCounts(m: Map): (seq[int], seq[int]) =
  (m.mapIt(it.x).toCountTable.zeroCounts,
   m.mapIt(it.y).toCountTable.zeroCounts)

print map1.zeroCounts # @[2, 5, 8], @[3, 7]

func expand(n: int, zeros: seq[int], age = 1): int =
  # assume zeros is increasing
  result = n
  for z in zeros:
    if z < n:
      result.inc age
    else:
      break

func expand(m: Map, age = 1): Map =
  let (xZeros, yZeros) = m.zeroCounts
  for p in m:
    result.add (p.x.expand(xZeros, age), p.y.expand(yZeros, age))

let map1e = expand map1
print map1e

func distance(p, q: Point): int =
  abs(p.x - q.x) + abs(p.y - q.y)

type
  PairwiseDistances = object
    distances: seq[int]
    n: int

func pairwiseDistances(m: Map): PairwiseDistances =
  for i in 0 .. m.high:
    for j in (i + 1) .. m.high:
      result.distances.add distance(m[i], m[j])
  result.n = m.len

func trapeizodal(n, m: int): int =
  assert m <= n
  (n*(n + 1) - m*(m + 1)) div 2

func dist(d: PairwiseDistances; i, j: int): int =
  assert i < d.n
  assert j < d.n
  if i == j:
    0
  else:
    let
      (mn, delta) = (min(i, j), max(i, j) - min(i, j))
      k = trapeizodal(d.n - 1, d.n - mn - 1)
    d.distances[k + delta - 1]

let
  dist1 = map1e.pairwiseDistances
print dist1.dist(0, 6) # 15
print dist1.dist(2, 5) # 17
print dist1.dist(7, 8) # 5

print sum dist1.distances # 374 ok

func part1(m: Map): int =
  m.expand.pairwiseDistances.distances.sum

print part1 map1
let puzzleMap = "puzzle.txt".readFile.parseMap
print part1 puzzleMap # 9522407

func part2(m: Map, age = 1000000): int =
  m.expand(age - 1).pairwiseDistances.distances.sum

print part2(map1, age = 10)
print part2(map1, age = 100)
print part2 puzzleMap
