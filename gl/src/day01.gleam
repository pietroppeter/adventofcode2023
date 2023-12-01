import gleam/io
import simplifile
import gleam/string
import gleam/list


fn read_input() {
  let filepath = "../day01/input.txt"
  let assert Ok(result) = simplifile.read(from: filepath)
  result
}

pub fn part1(text: String) -> Int {
  string.split(text, on: "\n")
  |> list.length
}

pub fn main() {
  io.println("Hello day 1")
  let input = read_input()
  io.println(input)
}
