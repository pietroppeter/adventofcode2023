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

let grid1 = """
.....
.S-7.
.|.|.
.L-J.
.....""".parseGrid
let gridPuzzle = "puzzle.txt".readFile.parseGrid
print part1 grid2
print part1 grid1
print part1 gridPuzzle

func inclGrid(s: var HashSet[Vec2], g: Grid, l: seq[Dir2], v: Vec2): int =
  if v notIn s and v notIn l.mapIt(it.vec) and v in g:
    s.incl v
    result = 1

func replaceStart(g: Grid): Grid =
  result = g
  let v = g.findStart
  let sn = g.linkNeighbours(v).mapIt(it.dir)
  let c =
    if sn == @[up, down]:
      '|'
    elif sn == @[up, right]:
      'L'
    elif sn == @[up, left]:
      'J'
    elif sn == @[right, down]:
      'F'
    elif sn == @[right, left]:
      '-'
    elif sn == @[down, left]:
      '7'
    else:
      ' '
  if c == ' ':
    raise ValueError.newException "unexpected start neighbours " & $sn
  result[v] = c



func findInside(g: Grid, loop: seq[Dir2]): HashSet[Vec2] =
  # go around the loop and add everything to the right
  let g = replaceStart g
  var count = 0
  for dv in loop:
    if (g[dv.vec] in ['|', '7'] and dv.dir == up) or
       (g[dv.vec] == 'J' and dv.dir == right):
      # add to right
      count.inc result.inclGrid(g, loop, (dv.vec.x + 1, dv.vec.y))
    elif (g[dv.vec] in ['|', 'L'] and dv.dir == down) or
         (g[dv.vec] == 'F' and dv.dir == left):
      # add to left
      count.inc result.inclGrid(g, loop, (dv.vec.x - 1, dv.vec.y))
    elif (g[dv.vec] in ['-', 'F'] and dv.dir == left) or
         (g[dv.vec] == '7' and dv.dir == up):
      # add up
      count.inc result.inclGrid(g, loop, (dv.vec.x, dv.vec.y - 1))
    elif (g[dv.vec] in ['-', 'J'] and dv.dir == right) or
         (g[dv.vec] == 'L' and dv.dir == down):
      # add down
      count.inc result.inclGrid(g, loop, (dv.vec.x, dv.vec.y + 1))
  #debugPrint result
  # now look to expand the frontier of neighbours
  var
    frontier = result
    toRemove = initHashSet[Vec2]()
    
  while frontier.len > 0:
    var newlyAdded = initHashSet[Vec2]()
    for v in frontier:
      count = 0
      for v2 in v.dirNeighbours: # just neighbours would be fine too
        let cinc = result.inclGrid(g, loop, v2.vec) 
        count.inc cinc
        if cinc > 0:
          newlyAdded.incl v2.vec
      if count == 0:
        toRemove.incl v
    frontier = frontier - toRemove + newlyAdded

func reverse(loop: seq[Dir2]): seq[Dir2] =
  for dv in loop:
    result.add (reverse dv.dir, dv.fromVec)

func xymax(g: Grid): (int, int) =
  let xmax = g.keys.toSeq.mapIt(it.x).max
  let ymax = g.keys.toSeq.mapIt(it.y).max
  (xmax, ymax)

func touchesBorder(g: Grid, inside: HashSet[Vec2]): bool =
  let (xmax, ymax) = xymax g
  for v in inside:
    if v.x == 0 or v.y == 0 or v.x == xmax or v.y == ymax:
      return true

func findInside(g: Grid): HashSet[Vec2] =
  let loop = loopAround g
  result = g.findInside loop
  if g.touchesBorder result:
    result = g.findInside loop.reverse

func part2(g: Grid): int =
  g.findInside.len

let grid3 = """...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........""".parseGrid
let grid4 = """.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...""".parseGrid
let grid5 = """FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L""".parseGrid

print part2 grid1 # 1
print part2 grid2 # 1
print part2 grid3 # 4
print part2 grid4 # 8
print part2 grid5 # 10

#print part2 gridPuzzle
# 1241 too high
# 381 too high
# 265 too low
# 259 not right

func toString(g: Grid, inside = initHashSet[Vec2]()): string =
  let (xmax, ymax) = xymax g
  let loop = (loopAround g).mapIt(it.vec)
  for y in 0 .. ymax:
    for x in 0 .. xmax:
      if (x, y) in inside:
        result.add '*'
      elif (x, y) in g and (x, y) in loop:
        result.add g[(x, y)]
      else:
        result.add '.'
    result.add '\n'

echo "---grid4"
echo grid4.toString(grid4.findInside)
echo "---grid5"
echo grid5.toString(grid5.findInside)

# invented for debugging
let grid6 = """
..........
.F------7.
.|......|.
.|......|.
.|......|.
.|......|.
.|......|.
.|......|.
.S------J.
..........""".parseGrid
echo "---grid6"
echo grid6.toString(grid6.findInside)

print part2 gridPuzzle
# "solution.txt".writeFile (gridPuzzle.toString(gridPuzzle.findInside))