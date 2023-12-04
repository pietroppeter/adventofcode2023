import batteries, print
import ../aoc

let example1 = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"""
let expect1 = 13

type
  Card = object
    id: int
    wins: seq[int]
    nums: seq[int]

func parseCard(line: string): Card =
  let 
    (cardPart, restPart) = line.split2 ':'
    (winPart, numPart) = restPart.strip.split2 '|'
    (_, idPart) = cardPart.split2 ' '
  result.id = parseInt idPart.strip
  result.wins = winPart.replace("\t", " ").strip.split(' ').filterIt(it.len > 0).mapIt(parseInt strip it)
  result.nums = numPart.replace("\t", " ").strip.split(' ').filterIt(it.len > 0).mapIt(parseInt strip it)

func parseCards(text: string): seq[Card] =
  for line in text.splitLines:
    result.add line.parseCard

let cards1 = example1.parseCards
print cards1

func points(c: Card): int =
  for num in c.nums:
    if num in c.wins:
      inc result
  if result > 0:
    result = 2^(result - 1)

func part1(cards: seq[Card]): int =
  for card in cards:
    result.inc card.points

print cards1.part1 # ok 13
let puzzle = "input.txt".readFile.parseCards
print part1 puzzle
# ok part1 

func matchingNumbers(c: Card): int =
  for num in c.nums:
    if num in c.wins:
      inc result

func part2(cards: seq[Card]): int =
  var counts = newSeq[int](cards.len)
  for i in 0 .. counts.high:
    counts[i] = 1
  
  for i, c in cards:
    let m = c.matchingNumbers
    for j in 1 .. m:
      counts[i + j] += counts[i]
  
  sum counts

print cards1.part2
print puzzle.part2