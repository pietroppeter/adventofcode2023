# we actually have maxplit parameter in strutils.split! all of the stuff below is redundant

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

when isMainModule:
  doAssert (" A |B".split2 '|') == (" A ", "B")
  doAssert ("1,2,3".split3 ',') == ("1", "2", "3")

  import macros

  dumpTree:
    79 14 55 13
  #[
    StmtList
      Command
        IntLit 79
        Command
          IntLit 14
          Command
            IntLit 55
            IntLit 13
  ]#
  # -> @[79, 14, 55, 13]
  dumpTree: @[79, 14, 55, 13]
  #[
    StmtList
      Prefix
        Ident "@"
        Bracket
          IntLit 79
          IntLit 14
          IntLit 55
          IntLit 13
  ]#

  dumpTree:
    50 98 2
    52 50 48
  #[
    StmtList
      Command
        IntLit 50
        Command
          IntLit 98
          IntLit 2
      Command
        IntLit 52
        Command
          IntLit 50
          IntLit 48
  ]#
  # -> @[@[50, 98, 2], @[52, 50, 48]]
  dumpTree: @[@[50, 98, 2], @[52, 50, 48]]
  #[
    StmtList
      Prefix
        Ident "@"
        Bracket
          Prefix
            Ident "@"
            Bracket
              IntLit 50
              IntLit 98
              IntLit 2
          Prefix
            Ident "@"
            Bracket
              IntLit 52
              IntLit 50
              IntLit 48
  ]#