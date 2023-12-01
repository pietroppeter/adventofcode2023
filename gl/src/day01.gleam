import gleam/io
import simplifile
import gleam/string
import gleam/list
import gleam/int


fn read_input() {
  let filepath = "../day01/input.txt"
  let assert Ok(result) = simplifile.read(from: filepath)
  result
}

fn calibration(line: String) -> Int {
  string.length(line)
}

pub fn part1(text: String) -> Int {
  string.split(text, on: "\n")
  |> list.map(calibration)
  |> int.sum
}

pub fn main() {
  io.println("Hello day 1")
  let input = read_input()
  io.println(input)
}
