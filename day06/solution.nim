import batteries, print

type
  Data = tuple[time, record: int64] 
  Document =
    seq[Data]

let example1 = @[
  (7'i64, 9'i64),
  (15'i64, 40'i64),
  (30'i64, 200'i64),
]

let puzzle = @[
  (48'i64, 261'i64),
  (93'i64, 1192'i64),
  (84'i64, 1019'i64),
  (66'i64, 1063'i64),
]
# (48938466, 261119210191063)

converter toInt64(num: int): int64 = num.int64

converter toInt64Data(t: (int, int)): (int64, int64) = (t[0].int64, t[1].int64)

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

print wins (71530, 940200) # 71503 ok
print wins (48938466'i64, 261119210191063)
