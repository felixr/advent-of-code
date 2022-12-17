(use ../utils)
(import spork/generators :as g)
(def day "17")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def width 7)
# ####
# 
# .#.
# ###
# .#.
# 
# ..#
# ..#
# ###
# 
# #
# #
# #
# #
# 
# ##
# ##
# 

(def input
  (->>
    (slurp infname)
    (string/trim)
    (map (fn [c]
           (match (string/from-bytes c)
             ">" :right
             "<" :left)))))

(def rocks
  [@{:name "-" :shape [[1 1 1 1]]}
   @{:name "+" :shape [[0 1 0]
                       [1 1 1]
                       [0 1 0]]}
   @{:name "L" :shape [[0 0 1]
                       [0 0 1]
                       [1 1 1]]}
   @{:name "I" :shape [[1] [1] [1] [1]]}
   @{:name "O" :shape [[1 1] [1 1]]}])

(defn collision? [rock grid rx ry]
  (any? (seq [[dy ln] :in (enumerate (reverse (rock :shape)))
              dx :range [0 (length ln)]
              :when (= 1 (ln dx))]
          (def y (+ ry dy))
          (def x (+ rx dx))
          (or (< y 0) (< x 0) (> x 6)
              (get grid [y x])))))

(defn blow [rock dir grid]
  (def rwidth (length (first (rock :shape))))
  (match dir
    :left (when (not (collision? rock grid (dec (rock :x)) (rock :y)))
            (put rock :x (dec (rock :x))))
    :right (when (not (collision? rock grid (inc (rock :x)) (rock :y)))
             (put rock :x (inc (rock :x))))))

(defn stuck [rock grid]
  (def ry (rock :y))
  (def rx (rock :x))
  (def sh (length (rock :shape)))
  (def sw (length (first (rock :shape))))
  (collision? rock grid rx (dec ry)))

(defn put-rock [rock grid]
  (def ry (rock :y))
  (def rx (rock :x))
  (def sh (length (rock :shape)))
  (def sw (length (first (rock :shape))))
  (loop [[dy ln] :in (enumerate (reverse (rock :shape)))
         dx :range [0 (length ln)]
         :when (= 1 (ln dx))]
    (put grid [(+ ry dy) (+ rx dx)] (rock :name)))
  (+ ry sh))

(def grid @{})
(each x (range 7) (put grid [-1 x] "_"))
(def moves (g/cycle input))


(var height 0)
(var i 0)

(def heights @[])
(loop [r :in (g/take 5000 (g/cycle rocks))]
  (def rock (table/clone r))
  (set (rock :x) 2)
  (set (rock :y) (+ height 3))
  (var done false)
  (while (not done)
    (when false
      (def g (table/clone grid))
      (put-rock rock g)
      (print-grid-flipped g))
    (def move (resume moves))
    (blow rock move grid)
    (if (stuck rock grid)
      (set done true)
      (set (rock :y) (dec (rock :y)))))
  #(pp [(rock :name) move]))
  (def newheight (max height (put-rock rock grid)))
  (+= i 1)
  (array/push heights (- newheight height))
  (set height newheight))

(print "Part 1: " (sum (take 2022 heights)))

(def data (array/slice heights 1000))
(def pattern-length (first (seq [n :range [10 2000]
                                 :let [a (array/slice data 0 n)
                                       b (array/slice data n (* 2 n))]
                                 :when (deep= a b)]
                             n)))

(def pattern (array/slice heights 1000 (+ 1000 pattern-length)))

(defn calc [runs]
  (+ (sum (array/slice heights 0 1000))
     (*
       (sum pattern)
       (math/floor (/ (- runs 1000) (length pattern))))
     (sum (array/slice pattern 0 (mod (- runs 1000) (length pattern))))))

(print "Part 2: " (calc 1000000000000))
