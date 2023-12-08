import batteries, print

let example1 = """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)"""

let example2 = """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)"""

type
  Map = object
    instructions: string
    graph: Table[string, tuple[left, right: string]]
    i: int # index of current instruction
    node: string # current node
    steps: int

func parseMap(text: string): Map =
  let split1 = text.strip.split("\n\n", maxsplit = 1)
  assert split1.len == 2, $split1
  result.instructions = split1[0]
  for line in split1[1].splitLines:
    let split2 = line.strip.split(" = ", maxsplit = 1)
    assert split2.len == 2, $split2
    let split3 = split2[1].strip(chars = {'(', ')'}).split(", ")
    assert split3.len == 2, $split3
    result.graph[split2[0]] = (split3[0], split3[1])
  assert "AAA" in result.graph
  assert "ZZZ" in result.graph
  for instr in result.instructions:
    assert instr == 'L' or instr == 'R'
  result.node = "AAA"

var
  map1 = example1.parseMap
  map2 = example2.parseMap

print map1
print map2

proc step(m: var Map) =
  let instr = m.instructions[m.i]
  m.node = if instr == 'L': m.graph[m.node].left else: m.graph[m.node].right
  inc m.i
  inc m.steps
  if m.i >= m.instructions.len:
    m.i -= m.instructions.len

proc traverse(m: var Map) =
  while m.node != "ZZZ":
    step m

func part1(m: Map): int =
  var m = m
  m.i = 0
  m.steps = 0
  m.node = "AAA"
  traverse m
  m.steps

print part1 map1
print part1 map2

let puzzleMap = "puzzle.txt".readFile.strip.parseMap
print part1 puzzleMap