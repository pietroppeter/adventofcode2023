import batteries
import print

let input = readFile "input.txt"

let example1 = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"""

type
  Draw = tuple[red, green, blue: int]
  Game = object
    id: int
    draws: seq[Draw]
  Constraint  = Draw

let constraint1 = (12, 13, 14)

func split2(text: string, sep: char): (string, string) =
  var i = 0
  while i < text.len:
    let c = text[i]
    if c == sep:
      inc i
      break
    result[0].add c 
    inc i
  while i < text.len:
    let c = text[i]
    result[1].add c 
    inc i

print "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green".split2 ':'

func split3(text: string, sep: char): (string, string, string) =
  var i = 0
  while i < text.len:
    let c = text[i]
    if c == sep:
      inc i
      break
    result[0].add c 
    inc i
  while i < text.len:
    let c = text[i]
    if c == sep:
      inc i
      break
    result[1].add c 
    inc i
  while i < text.len:
    let c = text[i]
    result[2].add c 
    inc i

type
  Color = distinct string

proc update(draw: var Draw, col: Color) =
  let (num, name) = col.string.strip.split2 ' '
  let i = parseInt(num.strip)
  case name.strip:
    of "red":
      draw.red = i
    of "green":
      draw.green = i
    of "blue":
      draw.blue = i
    else:
      raise ValueError.newException "should not happen: " & name.strip.repr 

func parseDraw(text: string): Draw =
  let (col1, col2, col3) = text.split3 ','
  result.update(col1.Color)
  if col2.len > 0:
    result.update(col2.Color)
  if col3.len > 0:
    result.update(col3.Color)

func parseGame(line: string): Game =
  let (prefix, draws) = line.split2 ':'
  doAssert prefix.startsWith "Game "
  result.id = parseInt(prefix[5 .. ^1].strip)
  result.draws = draws.strip.split(';').mapIt(strip it).mapIt(parseDraw it)

func parseGames(text: string): seq[Game] =
  text.splitLines.toSeq.mapIt(parseGame it)

let games1 = example1.parseGames
print games1

# ok parsing works fine
func `<`(d: Draw, c: Constraint): bool =
  d.red <= c.red and d.green <= c.green and d.blue <= c.blue

func isPossible(game: Game, constraint: Constraint): bool =
  game.draws.allIt(it < constraint)

func part1(games: seq[Game], constraint: Constraint): int =
  for game in games:
    if game.isPossible constraint:
      result.inc game.id

print games1.part1 constraint1
print input.parseGames.part1 constraint1
# part 1 ok

func minSet(game: Game): Constraint =
  var c = result
  for d in game.draws:
    if d.red > c.red:
      c.red = d.red
    if d.green > c.green:
      c.green = d.green
    if d.blue > c.blue:
      c.blue = d.blue
  c

func power(c: Constraint): int = c.red*c.blue*c.green

func part2(games: seq[Game]): int =
  for game in games:
    result.inc game.minSet.power

print games1.part2
print input.parseGames.part2
# part 2 ok
