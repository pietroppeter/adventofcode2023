func split2*(text: string, sep: char): (string, string) =
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

func split3*(text: string, sep: char): (string, string, string) =
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
