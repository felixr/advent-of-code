(use ../utils)
(def day "12")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(defn color [str r g b]
  (string/format "\x1b[38;2;%d;%d;%dm%s\x1b[0m" r g b str))

(defn two [argb &opt brgb]
  (default brgb [0 0 0])
  (string/format "\x1b[38;2;%d;%d;%dm\x1b[48;2;%d;%d;%dm▌\x1b[0m" 
                 ;argb ;brgb))

(defn gray [str g] 
  (string "\e[48;5;" (+ 232 g) "m" str "\e[0m"))

(defn color-char [n]
  (match n 
   -14 [255 0 0]
   -28 [0 255 0]
   (do
     (def g (math/ceil (* 256 (/ n 26))))
     [g g g])))


(pp (- (chr "S") (chr "a")))
(pp (- (chr "E") (chr "a")))

(def input
  (->>
   (slurp infname)
   (string/trim)
   (string/split "\n")
   (map values)
   (map2 |(- $ (chr "a")))))

(comment (each l input
          (print (string ;(map |(two ;$) (partition 2 (map color-char l)))))))

(def grid @{})
(def steps @{})
(var start [])
(var end [])
(defn init []
  (loop [r :range [0 (length input)]
         c :range [0 (length (first input))]
         :let [val (get (get input r) c)]]
      (when (= val -14)
        (set start [r c]))
      (when (= val -28)
        (set end [r c]))
      (put steps [r c] 99999999)
      (put grid [r c] 
           (match val
               -14 0
               -28 26
                val))))

(defn add2 [[a b] [x y]]
  [(+ a x) (+ b y)])

(defn neighbours [[r c]]
  (map |(add2 [r c] $) [[0 1] [1 0] [0 -1] [-1 0]]))


(defn part1 []
  (init)
  (def to-visit @[start])
  (put steps start 0)

  (while (not (empty? to-visit))
    (def cur (first to-visit))
    (def cur-hgt (get grid cur))
    (def cur-steps (get steps cur))
    (array/remove to-visit 0)
    (each nb (neighbours cur)
      (def hgt (get grid nb))
      (when (and hgt (<= (- hgt cur-hgt) 1))
        (when (< (inc cur-steps) (get steps nb))
          (array/push to-visit nb)
          (put steps nb (inc cur-steps))))))
  (print "Part 1: " (steps end)))
(part1)

(comment (loop [r :range [0 (length input)]]
          (print (string ;(map |(get steps [r $]) (range 0 (length (first input))))))))

  
(defn part2 []
  (init)
  (def to-visit @[end])
  (put steps end 0)

  (while (not (empty? to-visit))
    (def cur (first to-visit))
    (def cur-hgt (get grid cur))
    (def cur-steps (get steps cur))
    (array/remove to-visit 0)
    (each nb (neighbours cur)
      (def hgt (get grid nb))
      (when (and hgt (<= (- cur-hgt hgt) 1))
        (when (< (inc cur-steps) (get steps nb))
          (array/push to-visit nb)
          (put steps nb (inc cur-steps))))))
  (def candidates (filter (fn [[k v]] (= v 0)) (pairs grid)))
  (print "Part 2: " (min ;(map |(get steps (first $)) candidates))))
(part2)

