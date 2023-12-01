import gleeunit
import gleeunit/should
import day01

pub fn main() {
  gleeunit.main()
}

pub fn day01_part1_test() {
  day01.part1()
  |> should.equal(42)
}