import nimib

nbInit
nbText: """## Advent of Code 2023, Day 24

We are given position and velocity of hail particles
moving in 3-dimensional space (all integer values of course).

In Part 1 we are asked to find if forward paths intersect
when project in 2-dimensional X-Y space,
looking only in a limited range given by a min and max
coordinate (valid both for X and Y).

Let's start by parsing the data, using the example
"""
nbCode:
  let exampleText = """
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3"""
  
  type
    Vec3 = tuple[x, y, z: int]
    PhaseCoord = tuple[pos, vel: Vec3]
  
  import std / [strscans, strutils]

  func parse(text: string, reducePos = 0): seq[PhaseCoord] =
    var c: PhaseCoord
    for line in text.splitLines:
        if not scanf(line, "$i,$s$i,$s$i$s@$s$i,$s$i,$s$i$s", c.pos.x, c.pos.y, c.pos.z, c.vel.x, c.vel.y, c.vel.z):
            raise ValueError.newException "error parsing line: " & line
        c.pos.x -= reducePos
        c.pos.y -= reducePos
        c.pos.z -= reducePos
        result.add c

  let example = parse exampleText
  for c in example:
    echo c

nbText: """
Ok, the data is parse correctly.

Now, to test foward path intersection inside a defined area
I will find the intersection between two lines and check that:
- it is inside the area
- it is in forward path for both hailstones
"""
nbCode:
  import std / options

  func linearSystem(c: PhaseCoord): (int, int, int) =
    # from
    #   x = c.pos.x + (c.vel.x) t
    #   y = c.pos.y + (c.vel.y) t
    # to
    #   a x + b y = c
    # return (a, b, c)
    # cross multiplying x with c.vel.y and y with c.vel.x I remove t:
    #   (c.vel.y) x - (c.vel.x) y = c.vel.y c.pos.x - c.vel.x c.pos.y
    return (c.vel.y, -c.vel.x, c.vel.y * c.pos.x - c.vel.x * c.pos.y)

  func future(c: PhaseCoord, x: float): bool =
    (x > c.pos.x.float and c.vel.x > 0) or (x.float < c.pos.x.float and c.vel.x < 0)

  func intersect2d(c1, c2: PhaseCoord, min=7.0, max=27.0): Option[tuple[x, y: float]] =
    # reduce to a linear system
    #   a x + b y = c
    #   d x + e y = f
    # and solve with Cramer
    let
      (a, b, c) = linearSystem c1
      (e, f, g) = linearSystem c2
      det = a.float*f.float - b.float*e.float
      detX = c.float*f.float - b.float*g.float
      detY = a.float*g.float - c.float*e.float
    if det == 0:
      return # None
    let
      x = detX.float / det.float
      y = detY.float / det.float
    if x < min or x > max or y < min or y > max:
      return
    if not c1.future(x) or not c2.future(x):
      return
    return some((x, y))

  echo intersect2d(example[0], example[1]) # meet inside
  echo intersect2d(example[0], example[3]) # meet outside
  echo intersect2d(example[0], example[4]) # meet in past path

nbText: "Ok, works as expected, let's try it on the example."
nbCode:
  func solution(hail: seq[PhaseCoord], min=7.0, max=27.0): int =
    for i in 0 ..< hail.high: # one less than possible
      for j in (i + 1) ..< len(hail):
        if intersect2d(hail[i], hail[j], min=min, max=max).isSome:
          inc result

  echo solution example # expect 2

nbText: "Also works as expected, let's try it on the real puzzle."
nbCode:
  let
    puzzle = parse("puzzle.txt".readFile, reducePos = 200000000000000.int)
  echo len(puzzle)
  echo solution(puzzle, min=0.0, max=200000000000000.0)

nbText: """
It works! ⭐

Had issues with solution:
- determinant overflows of 64 bit integers
- tried to reduce determinant
- solved issue by converting determinant to float directly

Now onto part 2, and it does get a bit crazy,
I am told that throwing a single rock in 3d space
I can hit all hailstones. There is a particular position and
velocity that let's me do that.

It seems a problem rather easy to generate, but a bit harder to solve.
"""

nbSave

