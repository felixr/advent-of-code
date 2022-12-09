(use ../utils)
(def day "09")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
   (slurp infname)
   (string/trim)
   (string/split "\n")
   (map (partial string/split " "))
   (map (tfun keyword scan-number))))

(defn move-dir [s]
  (match s
    :U [0 -1]
    :D [0 1]
    :L [-1 0]
    :R [1 0]))

(defn move-tail [s]
  (match s
    :U [0 1]
    :D [0 -1]
    :L [1 0]
    :R [-1 0]))

(defn sign [a]
  (cond 
    (< a 0) -1
    (> a 0) 1
    0))
  
# T H
(defn move-knot [[a b] [x y]]
  (pp [[a b] [x y]])
  (def dx (- a x))
  (def dy (- b y))
  (add2 [a b] [(- (sign dx)) (- (sign dy))]))

(defn is-neighbour? [[a b] [x y]]
  (let [d1 (- a x) 
        d2 (- b y)]
     (>= 1.42 (math/sqrt (+ (* d1 d1) (* d2 d2))))))

(defn add2 [[a b] [x y]]
 [(+ a x) (+ b y)])

(defn part1 []
  (var H [0 0])
  (var T [0 0])
  (def grid @{[0 0] 1})
  (loop [[dir cnt] :in input]
    (repeat cnt 
      (set H (add2 H (move-dir dir)))
      (when (not (is-neighbour? H T))
       (set T (add2 H (move-tail dir)))
       (set (grid T) 1)))))

(def K (take 10 (rep [0 0])))

(def grid @{[0 0] 1})
(var i 0)
(loop [[dir cnt] :in input]
  (repeat cnt 
    (set (K 0) (add2 (K 0) (move-dir dir)))
    (var last-dir dir)
    (for i 1 10
     (when (not (is-neighbour? (K i) (K (dec i))))
       (def from (K i))
       (set (K i) (move-knot (K i) (K (dec i))))))
    (set (grid (last K)) (+= i 1))))

(comment
  (def xmin (min ;(map first (keys grid))))
  (def xmax (max ;(map first (keys grid))))
  (def ymin (min ;(map last (keys grid))))
  (def ymax (max ;(map last (keys grid))))


  (loop [y :range [ymin (inc ymax)]]
    (print
      (string/join
        (map |(if (grid [$ y]) "#" ".")
             (range xmin (inc xmax)))))))

(print "Part 2:" (length grid))
