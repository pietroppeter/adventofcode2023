import gleam/io
import gleam/string
import gleam/list
import gleam/result

// naive example from https://github.com/python/cpython/issues/74902
const naive5 = "naïve"

fn naive6() {
  [110, 97, 105, 776, 118, 101]
  |> list.map(string.utf_codepoint)
  |> result.values
  |> string.from_utf_codepoints
}

pub fn main() {
  let naive6 = naive6()
  io.debug(string.to_graphemes("🏳️‍🌈")) // ["🏳️‍🌈"]
  io.debug(string.to_utf_codepoints("🏳️‍🌈")) // [127987, 65039, 8205, 127752]
  io.debug(string.to_graphemes(naive5))
  io.debug(string.to_graphemes(naive6))
  io.debug(string.length(naive5))
  io.debug(string.length(naive6))
  io.debug(string.to_utf_codepoints(naive5))
  io.debug(string.to_utf_codepoints(naive6))
}
