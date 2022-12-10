(use ../utils)
(def day "10")
(var test? true)

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

(comment
  (var cycle 1)
  (var regx  1)
  (var regvals @[1])
  (def cmds (array/slice input))
  (loop [[cmd v] :in cmds]
    (if (= cmd :noop)
      (do 
        (+= cycle 1)
        (array/push regvals regx))
      (do
        (+= cycle 1)
        (array/push regvals regx)
        (+= cycle 1)
        (+= regx v)
        (array/push regvals regx))))

  (map regvals [20 60 100 140 180 220])
  (map regvals (map dec [20 60 100 140 180 220]))
  # 21 19 18 21 16 18
  (sum (map |(* (inc $) (regvals $)) (map dec [20 60 100 140 180 220]))))



(var cycle 0)
(var regx  1)
(var regvals @[1])
(var pixels @[@[] @[] @[] @[] @[] @[] @[]])
              

(defn draw []
 (def row (math/floor (/ (dec cycle) 40))) 
 (def col (% (dec cycle) 40))
 (array/push (pixels row) "#"))

(def cmds (array/slice input))
(loop [[cmd v] :in cmds]
  (if (= cmd :noop)
    (do 
      (+= cycle 1)
      (draw))
    (do
      (+= cycle 1)
      (draw)
      (+= cycle 1)
      (+= regx v)
      (draw))))


(map print (map |(string ;$) pixels))
