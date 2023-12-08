import batteries, print

let example1 = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"""

type
  Hand = tuple[hand: string, bid: int]
  Hands = seq[Hand]

func parseHands(text: string): Hands =
  for handLine in text.splitLines:
    let split1 = handLine.split(maxsplit = 1)
    result.add (split1[0], parseInt(split1[1]))

let hands1 = parseHands example1
print hands1

type handKind = enum
  High,
  Pair, 
  TwoPairs, 
  Three, 
  House, 
  Four, 
  Five,

func kind(h: Hand): handKind =
  let hand = h.hand
  assert hand.len == 5
  var counts = toCountTable[char](hand.toSeq)
  let first = largest counts
  counts.del first.key
  let second = if first.val == 5: first else: largest counts
  if first.val == 5:
    Five
  elif first.val == 4:
    Four
  elif first.val == 3 and second.val == 2:
    House
  elif first.val == 3: # second.val == 1
    Three
  elif first.val == 2 and second.val == 2:
    TwoPairs
  elif first.val == 2: # second.val == 1
    Pair
  else:
    High

for hand in hands1:
  print hand, hand.kind

func val(c: char): int =
  case c:
    of '2' .. '9':
      ord(c) - ord('0')
    of 'T':
      10
    of 'J':
      11
    of 'Q':
      12
    of 'K':
      13
    of 'A':
      14
    else:
      raise ValueError.newException "unexpected card " & $c

func cmp(h,k: Hand): int =
  # h < k -> negative
  assert h.hand.len == 5
  assert k.hand.len == 5
  let
    hKind = h.kind
    kKind = k.kind
  result = ord(hKind) - ord(kKind)
  if result != 0:
    return result
  for i in 0 .. 4:
    result = h.hand[i].val - k.hand[i].val
    if result != 0:
      return result

func part1(hands: Hands): int =
  var hands = hands
  sort(hands, cmp)
  for i, hand in hands:
    result += (i + 1)* hand.bid

print part1 hands1

let puzzleHands = "puzzle.txt".readFile.strip.parseHands
print part1 puzzleHands


func val2(c: char): int =
  case c:
    of 'J':
      0
    of '2' .. '9':
      ord(c) - ord('0')
    of 'T':
      10
    of 'Q':
      12
    of 'K':
      13
    of 'A':
      14
    else:
      raise ValueError.newException "unexpected card " & $c

func kind2(h: Hand): handKind =
  let hand = h.hand
  assert hand.len == 5
  var counts = toCountTable[char](hand.toSeq)
  let jokers = (key: 'J', val: counts['J'])
  counts.del 'J'
  var first = if jokers.val == 5: jokers else: largest counts
  counts.del first.key
  if jokers.val != 5:
    first.val += jokers.val
  var second = if first.val == 5: first else: largest counts
  
  if first.val == 5:
    Five
  elif first.val == 4:
    Four
  elif first.val == 3 and second.val == 2:
    House
  elif first.val == 3: # second.val == 1
    Three
  elif first.val == 2 and second.val == 2:
    TwoPairs
  elif first.val == 2: # second.val == 1
    Pair
  else:
    High

func cmp2(h,k: Hand): int =
  # h < k -> negative
  assert h.hand.len == 5
  assert k.hand.len == 5
  let
    hKind = h.kind2
    kKind = k.kind2
  result = ord(hKind) - ord(kKind)
  if result != 0:
    return result
  for i in 0 .. 4:
    result = h.hand[i].val2 - k.hand[i].val2
    if result != 0:
      return result

func part2(hands: Hands): int =
  var hands = hands
  sort(hands, cmp2)
  for i, hand in hands:
    result += (i + 1)* hand.bid

print part2 hands1
print part2 puzzleHands
