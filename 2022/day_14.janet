(use ../utils)
(def day "14")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def lineg
  ~{:number (cmt (<- (some :d)) ,scan-number)
    :pt (cmt (group (* :number "," :number)) ,tuple/slice)
    :main (* :pt (some (* " -> " :pt)))})

(defn expand-line [line]
  (map sorted (window 2 line)))

(def lines
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")
    (map (partial peg/match lineg))
    (mapcat expand-line)))

(def grid @{})

(defn init-grid []
  (table/clear grid)
  (each [[a b] [x y]] lines
    (if (= a x)
      (each c (range b (inc y)) (put grid [c a] "#"))
      (each r (range a (inc x)) (put grid [b r] "#")))))

(defn move [g [r c]]
  (def d [(inc r) c])
  (def dv (get g d))
  (cond
    (nil? dv) d
    (let [l [(inc r) (dec c)]
          r [(inc r) (inc c)]]
      (cond
        (nil? (get grid l)) l
        (nil? (get grid r)) r))))

(defn part1 []
  (init-grid)
  (var done false)
  (var i 0)
  (def min-row (min-of (map first (keys grid))))
  (def max-row (max-of (map first (keys grid))))
  (while (and (< i 100000) (not done))
    (var sand [-1 500])
    (while (and (not done) (move grid sand))
      (set sand (move grid sand))
      (if (< max-row (first sand))
        (set done true)))
    (+= i 1)
    (put grid sand "o"))

  (print "Part 1: " (dec i)))

(part1)

(defn part2 []
  (init-grid)
  (def max-row (max-of (map first (keys grid))))

  (map |(put grid [(+ 2 max-row) $] "#") (range (- 495 max-row) (+ 505 max-row)))

  (var done false)
  (var i 0)
  (def min-row (min-of (map first (keys grid))))
  (def max-row (max-of (map first (keys grid))))
  (while (and (< i 100000) (not done))
    (var sand [-1 500])
    (while (move grid sand)
      (set sand (move grid sand)))
    (+= i 1)
    (put grid sand "o")
    (if (= sand [0 500])
      (set done true)))

  (print "Part 2: " i))

(part2)
