import batteries, print

type
  Data = tuple[time, record: int] 
  Document =
    seq[Data]

let example1 = @[
  (7, 9),
  (15, 40),
  (30, 200),
]

let puzzle = @[
  (48, 261),
  (93, 1192),
  (84, 1019),
  (66, 1063),
]

func wins(data: Data): int =
  let
    t0 = data.time.float
    r = data.record.float
  # total distance when pressing for time t (< t0):
  # (t0 - t)*t
  # so we need to solve for zeros in:
  # (t0 - t)*t - r
  # and count integers between zeros
  # equation is equivalent to:
  # t^2 - t0*t + r
  # solution are classical
  # t1, t2 = -b +/- sqrt(b^2 - 4ac) / 2a
  let # could use a debugPrint here...
    mb = t0
    c = r
    sqrtDelta = sqrt(mb^2 - 4*c)
    t2 = 0.5*(mb + sqrtDelta)
    t1 = 0.5*(mb - sqrtDelta)
    it1 = ceil(t1)
    it2 = floor(t2)
    r1 = (t0 - it1)*it1
    r2 = (t0 - it2)*it2
  when false:
    debugPrint t0
    debugPrint r
    debugPrint t1
    debugPrint t2
    debugPrint it1
    debugPrint it2
    debugPrint r1
    debugPrint r2
  if r1 > (r + 0.1e-7):
    int(it2 - it1) + 1
  else:
    int(it2 - it1) - 1

for data in example1:
  print data, data.wins

func part1(doc: Document): int =
  result = 1
  for data in doc:
    result *= wins data

print part1 example1
print part1 puzzle
