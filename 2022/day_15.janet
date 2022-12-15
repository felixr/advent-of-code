(use ../utils)
(import spork/generators :as g)
(def day "15")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def grammar ~{:number (cmt (<- (* (? "-") :d+)) ,scan-number)
               :main (* "Sensor at x=" :number ", y=" :number
                        ": closest beacon is at x=" :number ", y=" :number (any :s))})
(def input
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")
    (map (partial peg/match grammar))
    (map (partial partition 2))))

(defn manhattan [[a b] [x y]]
  (+ (math/abs (- a x))
     (math/abs (- b y))))

(defn count-blocked [n]
  (def blocked @{})
  (loop [[sens beac] :in input
         :let [mh (manhattan sens beac)
               [sx sy] sens
               rest (- mh (math/abs (- n sy)))]
         :when (> rest 0)]
    (loop [x :range [(- sx rest) (+ sx rest 1)]]
      (put blocked [x n] "#")))

  (loop [[[sx sy] [bx by]] :in input]
    (if (= sy n)
      (put blocked [sx sy] nil))
    (if (= by n)
      (put blocked [bx by] nil)))
  (print (length blocked)))

# Part1:  4861076
# (count-blocked 2000000)

(defn in-reach-of? [pt [sens beac]]
  (def reach (manhattan sens beac))
  (def dist (manhattan sens pt))
  (<= dist reach))

(defn in-reach? [pt]
  (any? (g/map (partial in-reach-of? pt) input)))

(defn border [pt d]
  (seq [dx :range [0 (inc d)]
        dy :in [(- d dx) (- dx d)]]
    (add2 pt [dx dy])))

(loop [[sens beac] :in input
       :let [mh (manhattan sens beac)
             [sx sy] sens]]
  (loop [[x y] :in (border sens (inc mh))
         :when (and (< (max x y) 4000000)
                    (> (min x y) 0))]
    (when (not (in-reach? [x y]))
      (printf "x=%d, y=%d, score=%d" x y (+ y (* x 4000000)))
      (error "done"))))
