func parse(text: string): int =
  var onlyDigits: string
  for c in text:
    if c in '0' .. '9':
      onlyDigits.add c
  let
    first = onlyDigits[0]
    last = onlyDigits[^1]
  (ord(first) - ord('0'))*10 + (ord(last) - ord('0'))

var part1 = 0
for line in lines "input.txt":
  part1 += parse(line)
echo part1