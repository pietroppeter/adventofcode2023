import gleeunit
import gleeunit/should
import day01

pub fn main() {
  gleeunit.main()
}

const example1 = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"

pub fn day01_part1_test() {
  day01.part1(example1)
  |> should.equal(142)
}