import re

with open("inputs/day15_input.txt", "r") as f:
  lines = f.readlines()

data = [
    tuple(int(s) for s in re.findall(r"[-]?[0-9]+", line)) for line in lines
]
data = [((a, b), (x, y)) for a, b, x, y in data]


def manhattan(a, b):
  return abs(a[0] - b[0]) + abs(a[1] - b[1])


def in_reach_of(pt, sens, beac):
  reach = manhattan(sens, beac)
  dist = manhattan(sens, pt)
  return dist <= reach


def in_reach(p):
  for sens, beac in data:
    if in_reach_of(p, sens, beac):
      return True


def add2(a, b):
  return (a[0] + b[0], a[1] + b[1])


def border(pt, d):
  for dx in range(0, d + 1):
    for dy in [d - dx, dx - d]:
      yield add2(pt, (dx, dy))


for sens, beac in data:
  mh = manhattan(sens, beac)
  for x, y in border(sens, mh + 1):
    if min(x, y) >= 0 and max(x, y) <= 4000000:
      if not in_reach((x, y)):
        print(f"x={x}, y={y}, score={y + x * 4000000}")
        exit()
