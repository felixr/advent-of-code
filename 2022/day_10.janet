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
    (map (fn [c]
           (match c
             ["addx" a] [:addx (scan-number a)]
             ["noop"] [:noop 0])))))

(defn part1 []
  (var regx 1)
  (var regvals @[nil 1])
  (def cmds (array/slice input))
  (loop [[cmd v] :in cmds]
    (if (= cmd :noop)
      (do
        (array/push regvals regx))
      (do
        (array/push regvals regx)
        (+= regx v)
        (array/push regvals regx))))

  (print "Part1: " (sum (map |(* $ (regvals $)) [20 60 100 140 180 220]))))
(part1)


(defn part2 []
  (var cycle 0)
  (var regx 1)
  (var pixels @[@[] @[] @[] @[] @[] @[]])

  (defn draw []
    (def row (math/floor (/ cycle 40)))
    (def col (% cycle 40))
    (if (between? col (dec regx) (inc regx))
      (array/push (pixels row) "█")
      (array/push (pixels row) " ")))

  (def cmds (array/slice input))
  (loop [[cmd v] :in cmds]
    (if (= cmd :noop)
      (do
        (draw)
        (+= cycle 1))
      (do
        (draw)
        (+= cycle 1)
        (draw)
        (+= cycle 1)
        (+= regx v))))
  (each ln (map |(string ;$) pixels) (print ln)))
(part2)
