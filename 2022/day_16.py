import re
import functools
from itertools import chain, combinations

places = []
name_to_place = {}

with open("inputs/day16_input.txt", "r") as f:
  #with open("inputs/day16_test.txt", "r") as f:
  i = 0
  for l in f.readlines():
    valve, *tunnels = re.findall(r"[A-Z]{2}", l)
    rate = int(re.findall(r"[0-9]+", l)[0])
    name_to_place[valve] = i
    i += 1
    places.append(dict(valve=valve, tunnels=tunnels, rate=rate))

tunnels = []
rates = []
for p in places:
  tunnels.append(list(map(lambda n: name_to_place[n], p["tunnels"])))
  rates.append(p["rate"])

dist = []
nump = len(places)
for i in range(nump):
  d = []
  for j in range(nump):
    d.append(1 if j in tunnels[i] else 9999)
  dist.append(d)

for k in range(nump):
  for i in range(nump):
    for j in range(nump):
      dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])


@functools.cache
def explore(cur: int, unopened: frozenset[int], timeleft: int):
  vals = []
  if timeleft < 0 or len(unopened) == 0:
    return 0
  for valve in unopened:
    d = dist[cur][valve]
    timeleft_after_open = timeleft - d - 1
    if timeleft_after_open >= 0:
      vals.append(rates[valve] * timeleft_after_open +
                  explore(valve, unopened - {valve}, timeleft_after_open))
  return max(vals) if vals else 0


to_open = frozenset(x for x in range(nump) if rates[x] > 0)

# 1871
print("Part 1: %d" % explore(name_to_place["AA"], to_open, 30))


def powerset(s):
  return list(
      map(frozenset,
          chain.from_iterable(combinations(s, r) for r in range(len(s) + 1))))


# 2416
print("Part 2: %d" % max(
    explore(name_to_place["AA"], elephant, 26) +
    explore(name_to_place["AA"], to_open - elephant, 26)
    for elephant in powerset(to_open)))
