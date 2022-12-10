(use ../utils)
(def day "10")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")
    (map (partial string/split " "))
    (map (tfun keyword scan-number))
    (mapcat (fn [[c v]] (if v [0 v] 0)))))

(defn part1 []
  (var regx 1)
  (var regvals @[nil 1])
  (each v input
      (+= regx v)
      (array/push regvals regx))
  (print "Part1: " (sum (map |(* $ (regvals $)) [20 60 100 140 180 220]))))
(part1)


(defn part2 []
  (var regx 1)
  (var pixels (map array/new (range 6)))
  (each [cycle v] (enumerate input)
    (def row (math/floor (/ cycle 40)))
    (def col (mod cycle 40))
    (array/push (pixels row)
      (if (between? col (dec regx) (inc regx)) "█" " "))
    (+= regx v))
  (map print (map |(string ;$) pixels)))
(part2)
