from collections import Counter

example1 = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."""

Point = tuple[int, int]
Map = list[Point]


def parse_map(text: str) -> Map:
    return [
        (x, y)
        for y, line in enumerate(text.strip().splitlines())
        for x, c in enumerate(line)
        if c == "#"
    ]


map1 = parse_map(example1)
print(map1)
print(len(map1))


def zero_counts(c: Counter[int, int]) -> list[int]:
    return [n for n in range(max(c.keys())) if c[n] == 0]


def zero_counts_map(m: Map) -> (list[int], list[int]):
    cx = Counter(map(lambda p: p[0], m))
    cy = Counter(map(lambda p: p[1], m))
    return (zero_counts(cx), zero_counts(cy))


print(zero_counts_map(map1))


def expand(n: int, zeros: list[int], age=1) -> int:
    return n + sum([age for z in zeros if z < n])


def expand_map(m: Map, age=1) -> Map:
    xZeros, yZeros = zero_counts_map(m)
    return [(expand(p[0], xZeros, age), expand(p[1], yZeros, age)) for p in m]


map1e = expand_map(map1)
print(map1e)


def distance(p: Point, q: Point) -> int:
    return abs(p[0] - q[0]) + abs(p[1] - q[1])


def pairwise_distances(m: Map) -> list[int]:
    return [distance(m[i], m[j]) for i in range(len(m)) for j in range(len(m)) if i < j]


print(sum(pairwise_distances(map1e)))


def part1(m: Map) -> int:
    return sum(pairwise_distances(expand_map(m)))


with open("puzzle.txt", "r") as f:
    puzzle_map = parse_map(f.read())

print(part1(map1))  # 374
print(part1(puzzle_map))


def part2(m: Map, age=1000000) -> int:
    return sum(pairwise_distances(expand_map(m, age=age - 1)))


print(part2(map1, age=10))  # 1030
print(part2(map1, age=100))  # 8410
print(part2(puzzle_map))
