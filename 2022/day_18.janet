(use ../utils)
(def day "18")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")
    (map (partial string/split ","))
    (map2 scan-number)))


(def grid @{})
(loop [[x y z] :in input]
  (put grid [x y z] true))


(defn neighbours [[x y z]]
  (seq [[dx dy dz] :in
        [[1 0 0] [0 1 0] [0 0 1]
         [-1 0 0] [0 -1 0] [0 0 -1]]]
    [(+ x dx) (+ y dy) (+ z dz)]))

(defn part1 []
  (print "Part 1: "
         (sum (seq [cube :in input]
                (count nil? (map (partial get grid) (neighbours cube)))))))
(part1)

(def bounds
  (partition 2
             (seq [i :range [0 3]
                   [decinc minmax] :in [[dec min-of] [inc max-of]]]
               (decinc (minmax (map i input))))))


(defn in-bounds? [pt bounds]
  (every? (map |(between? (pt $) ;(bounds $)) (range (length pt)))))

(def steam @{})

# Flood fill the bounding box of the lava
# and count how often we touch lava.
(def stack @[(map first bounds)])
(var cnt 0)
(loop [cur :iterate (array/pop stack)]
  (unless (in steam cur)
    (put steam cur true)
    (loop [coords :in (neighbours cur)]
      (if (in grid coords)
        (+= cnt 1)
        (when (in-bounds? coords bounds)
          (array/push stack coords))))))

(print "Part 2: " cnt)
