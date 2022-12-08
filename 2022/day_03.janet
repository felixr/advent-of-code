(use ../utils)

(defn half [s]
  (def idx (/ (length s) 2))
  [(string/slice s 0 idx)
   (string/slice s idx)])

(defn mk-set [s]
  (def arr (map string/from-bytes s))
  (zipcoll arr arr))

(defn score [s]
  (def v (first s))
  (cond
    (> v 90) (inc (- v (first "a")))
    (+ 27 (- v (first "A")))))

(print
  (->> (slurp "inputs/day03_input.txt")
      (string/trim)
      (string/split "\n")
      (length)))

(print
  (->> (slurp "inputs/day03_input.txt")
     (string/trim)
     (string/split "\n")
     (map mk-set)
     (partition 3)
     (mapcat (partial reduce2 (swapf keep)))
     (map score)
     (sum)))

