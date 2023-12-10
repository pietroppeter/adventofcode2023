import batteries, print

let example2 = """
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ"""

type
  Direction = enum up, right, down, left
  Vec2 = tuple[x, y: int]
  Dir2 = tuple[dir: Direction, vec: Vec2]
  Grid = Table[Vec2, char]

func parseGrid(text: string): Grid =
  let text = text.strip
  var
    x = 0
    y = 0
  for c in text:
    if c == '\n':
      inc y
      x = 0
    else:
      result[(x, y)] = c
      inc x

let grid2 = parseGrid example2
print grid2

func findStart(g: Grid): Vec2 =
  for v, c in g:
    if c == 'S':
      return v

let start2 = findStart grid2
print start2

func dirNeighbours(v: Vec2): seq[Dir2] =
  @[
    (up, (v.x, v.y - 1)),
    (right, (v.x + 1, v.y)),
    (down, (v.x, v.y + 1)),
    (left, (v.x - 1, v.y)),
  ]

func linksFrom(c: char): seq[Direction] =
  # directions that points inside the pipe
  case c
  of '|':
    @[up, down]
  of '-':
    @[right, left]
  of 'F':
    @[up, left]
  of 'L':
    @[down, left]
  of 'J':
    @[down, right]
  of '7':
    @[up, right]
  of 'S':
    @[up, right, down, left]
  else:
    @[]

func reverse(d: Direction): Direction =
  case d
  of up:
    down
  of down:
    up
  of right:
    left
  of left:
    right

func linksTo(c: char): seq[Direction] =
  c.linksFrom.mapIt(reverse it)

func linkNeighbours(g: Grid, v: Vec2): seq[Dir2] =
  for dv in dirNeighbours(v):
    if v in g and dv.vec in g and dv.dir in g[v].linksTo and dv.dir in g[dv.vec].linksFrom:
      result.add dv

func findStartDir(g: Grid): Dir2 =
  let v = findStart g
  for dv in g.linkNeighbours(v):
    return dv
  raise ValueError.newException "no start dir"

print grid2.findStartDir

func nextDir(g: Grid, dv: Dir2): Dir2 =
  assert dv.vec in g
  for dv2 in g.linkNeighbours(dv.vec):
    if dv2.dir == reverse dv.dir:
      continue
    else:
      return dv2
  raise ValueError.newException "no next dir"

func loopAround(g: Grid): seq[Dir2] =
  var dv = findStartDir g 
  result.add dv
  while g[dv.vec] != 'S':
    dv = g.nextDir dv
    result.add dv

func fromVec(dv: Dir2): Vec2 =
  case dv.dir
  of up:
    (dv.vec.x, dv.vec.y + 1)
  of right:
    (dv.vec.x - 1, dv.vec.y)
  of down:
    (dv.vec.x, dv.vec.y - 1)
  of left:
    (dv.vec.x + 1, dv.vec.y)

func step(g: Grid, dv: Dir2): string =
  let v = dv.fromVec
  result.add g[v]
  result.add $v
  result.add " -" & $dv.dir & "> "
  result.add g[dv.vec]
  result.add $dv.vec

let loop2 = loopAround grid2
for dv in loop2:
  print grid2.step(dv)
print len loop2

func part1(g: Grid): int =
  let loop = loopAround g
  loop.len div 2

print part1 grid2
print part1 """
.....
.S-7.
.|.|.
.L-J.
.....""".parseGrid
print part1 "puzzle.txt".readFile.parseGrid

