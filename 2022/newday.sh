#!/bin/bash

day=$1
dayf=$(printf "%02d\n" $day)
curl https://adventofcode.com/2022/day/${day}/input --cookie "session=$(cat ~/.adventofcode.session)" > inputs/day${dayf}_input.txt


# cat <<EOF > day${day}.janet
# (use ../utils)
# (def day "${day}")
# (var test? false)
# 
# (def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))
# 
# (def input
#   (->>
#    (slurp infname)
#    (string/trim)
#    (string/split "\n")))
# EOF
