import gleam/io
import simplifile


fn read_input() {
  let filepath = "../day01/input.txt"
  let assert Ok(result) = simplifile.read(from: filepath)
  result
}

pub fn part1() {
  42
}

pub fn main() {
  io.println("Hello day 1")
  let input = read_input()
  io.println(input)
}
