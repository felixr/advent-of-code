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

# (pp grid)

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

(var lox 9999)
(var hix -9999)
(var loy 9999)
(var hiy -9999)
(var loz 9999)
(var hiz -9999)

(loop [[x y z] :in input]
  (set lox (min lox x))
  (set loy (min loy y))
  (set loz (min loz z))
  (set hix (max hix x))
  (set hiy (max hiy y))
  (set hiz (max hiz z)))

(-= lox 1)
(-= loy 1)
(-= loz 1)
(+= hix 1)
(+= hiy 1)
(+= hiz 1)
# (pp [lox hix loy hiy loz hiz]) 

(def steam @{})

(def stack @[[lox loy loz]])
(var cnt 0)
(while (not (empty? stack))
  (def cur (array/pop stack))
  (when (nil? (get steam cur))
    (put steam cur true)
    (loop [[x y z] :in (neighbours cur)]
      (if (not (nil? (get grid [x y z])))
        (+= cnt 1)
        (if (and (between? x lox hix)
                 (between? y loy hiy)
                 (between? z loz hiz))
          (array/push stack [x y z]))))))

(print "Part 2: " cnt)
