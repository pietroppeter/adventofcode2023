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

fn is_digit(c: UtfCodepoint) -> Bool {
  let assert Ok(zero) = "0" |> string.to_utf_codepoints |> list.first
  let assert Ok(nine) = "9" |> string.to_utf_codepoints |> list.first
  string.utf_codepoint_to_int(c) >= string.utf_codepoint_to_int(zero) && string.utf_codepoint_to_int(c) <= string.utf_codepoint_to_int(nine) 
}

fn digit_to_int(c: UtfCodepoint) -> Int {
  let assert Ok(zero) = "0" |> string.to_utf_codepoints |> list.first
  string.utf_codepoint_to_int(c) - string.utf_codepoint_to_int(zero) 
}

fn filter_digits(text: String) -> List(Int) {
  text |> string.to_utf_codepoints |> list.filter(is_digit) |> list.map(digit_to_int)
}

fn calibration(line: String) -> Int {
  let digits = filter_digits(line)
  let assert Ok(first) = list.first(digits)
  let assert Ok(last) = list.last(digits)
  first*10 + last
}

pub fn part1(text: String) -> Int {
  string.split(text, on: "\n")
  |> list.map(calibration)
  |> int.sum
}

fn fix_line(line: String) -> String {
  line
  |> string.replace("t", "tt") // eightwo -> eighttwo (or eighthree)
  |> string.replace("on", "oon") // zerone -> zeroone (but not four -> foour)
  |> string.replace("ei", "eei") // fiveight -> fiveeight (but not seven -> seeveen)
  |> string.replace("zero", "0")
  |> string.replace("one", "1")
  |> string.replace("two", "2")
  |> string.replace("three", "3")
  |> string.replace("four", "4")
  |> string.replace("five", "5")
  |> string.replace("six", "6")
  |> string.replace("seven", "7")
  |> string.replace("eight", "8")
  |> string.replace("nine", "9")
}

pub fn part2(text: String) -> Int {
  string.split(text, on: "\n")
  |> list.map(fix_line)
  |> list.map(calibration)
  |> int.sum
}

pub fn main() {
  let input = read_input()
  io.println("part1: " <> int.to_string(part1(input))) // 54081
  io.println("part2: " <> int.to_string(part2(input))) // 54649
}
