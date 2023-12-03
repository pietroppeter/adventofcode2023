import batteries, print

const example1 = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."""

type
  Num = object
    val: int
    x0, x1, y: int
  Sym = object
    ch: char
    x, y: int
  Schema = object
    nums: seq[Num]
    syms: seq[Sym]


func parseSchema(text: string): Schema =
  var
    x = 0
    y = 0
    num: Num
    c: char
  for line in text.splitLines:
    x = 0
    while x < line.len:
      c = line[x]
      case c:
        of '.':
          inc x
        of '0' .. '9':
          num.x0 = x
          num.y = y
          num.val = ord(c) - ord('0')
          inc x
          while x < line.len and (c = line[x]; c in '0' .. '9'):
            num.val = num.val*10 + ord(c) - ord('0')
            inc x
          num.x1 = x - 1
          result.nums.add num
        else:
          result.syms.add Sym(ch: c, x: x, y: y)
          inc x
    inc y

let schema1 = parseSchema example1
print schema1

func between(x, y, z: int): bool =
  x >= y and x <= z

func isClose(n: Num, s: Sym): bool =
  n.y.between(s.y - 1, s.y + 1) and s.x.between(n.x0 - 1, n.x1 + 1)

func isPartNumber(n: Num, syms: seq[Sym]): bool =
  for s in syms:
    if n.isClose s:
      return true

func part1(schema: Schema): int =
  for num in schema.nums:
    #debugPrint num
    if num.isPartNumber schema.syms:
      result += num.val

print part1 schema1

let myPuzzle = "input.txt".readFile.parseSchema

print part1 myPuzzle # 539433

func gearRatio(s: Sym, nums: seq[Num]): int =
  if s.ch != '*':
    return 0
  var count = 0
  result = 1
  for n in nums:
    if n.isClose s:
      inc count
      result *= n.val
  if count != 2:
    result = 0 

func part2(schema: Schema): int =
  for s in schema.syms:
    result.inc s.gearRatio schema.nums

print part2 schema1
print part2 myPuzzle # 75847567

