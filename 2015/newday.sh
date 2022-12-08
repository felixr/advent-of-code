#!/bin/bash

day=$(printf "%02d\n" $1)
curl https://adventofcode.com/2015/day/${day}/input --cookie "session=$(cat ~/.adventofcode.session)" > inputs/day0${day}_input.txt
touch inputs/day${day}_test.txt

cat <<EOF > day${day}.janet
(use ../utils)
(def day "${day}")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
   (slurp infname)
   (string/trim)
   (string/split "\n")))
EOF
