import example

print(example.seeds)

def idmap(tuples, n):
  for t in tuples:
    if t[1] <= n <= t[1] + t[2]:
      return t[0] + (n - t[1])
  return n

print(idmap(example.seed_to_soil_map, 79)) # 81
print(idmap(example.soil_to_fertilizer_map, 81)) # 81
print(idmap(example.fertilizer_to_water_map, 57)) # 53

def seed_to_location(namespace, n):
  for m in [
      namespace.seed_to_soil_map,
      namespace.soil_to_fertilizer_map,
      namespace.fertilizer_to_water_map,
      namespace.water_to_light_map,
      namespace.light_to_temperature_map,
      namespace.temperature_to_humidity_map,
      namespace.humidity_to_location_map,
    ]:
    n = idmap(m, n)
  return n

print(seed_to_location(example, 79)) # 82
print(seed_to_location(example, 14)) # 43

def part1(namespace):
  result = 1_000_000_000
  for seed in namespace.seeds:
    n = seed_to_location(namespace, seed)
    if n < result:
      result = n
  return result

print(part1(example)) # 35

import puzzle
print(part1(puzzle)) # 

