(use ../utils)
(def day "03")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (map string/from-bytes)))


(defn move [d]
  (match d
    ">" [0 1]
    "<" [0 -1]
    "^" [-1 0]
    "v" [1 0]))

(defn add2 [[a b] [x y]]
  [(+ a x) (+ b y)])

(defn part1 []
  (def houses @{})
  (var pt [0 0])
  (set (houses pt) 1)

  (loop [x :in input]
    (set pt (add pt (move x)))
    (set (houses pt) 1))
  (print "Part 1: " (length houses)))
(part1)


(split 2 input)

(defn part2 []
  (def [robot elve] (split 2 input))

  (def houses @{})
  (var pt [0 0])
  (set (houses pt) 1)

  (loop [x :in robot]
    (set pt (add pt (move x)))
    (set (houses pt) 1))

  (var pt [0 0])
  (loop [x :in elve]
    (set pt (add pt (move x)))
    (set (houses pt) 1))
  (print "Part 2: " (length houses)))

(part2)
