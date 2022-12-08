(use ../utils)
(var test? false)

(def infname (string "inputs/day05_" (if test? "test" "input") ".txt"))

(defn parse-move [m]
  (def [_ x _ f _ t](string/split " " m))
  (map scan-number [x f t]))

(def input
  (->>
   (slurp infname)
   (string/split "\n\n")))

(def moves (map parse-move (string/split "\n" (string/trim (last input)))))

(def plan-in (map2 string/trim (map (partial partition 4) (string/split "\n" (first input)))))

(defn replace [a b x]
  (if (= x a) b x))


(def tmp (->> (first input)
             (string/split "\n")
             (map (fn [x] (->> x
                               (split 4)
                               (|(get $ 1))
                               (map string/from-bytes)
                               (map (partial replace " " nil)))))))
(array/pop tmp)
(pp tmp)

(defn transpose [m]
  (def cols (length (first m)))
  (def rows (length m))
  (seq [c :range [0 cols]]
    (map |(get-in m [$ c]) (range 0 rows))))

(transpose tmp)

(def cols (length (last plan-in)))
(def rows (length plan-in))

(defn prep-data []
  (def data @[])
  (repeat cols (array/push data @[]))

  (loop [r :down-to [(- rows 2) 0] 
         c :range [0 cols]]
    (def v ((plan-in r) c))
    (if (< 0 (length (string/trim v)))
      (array/push (c data) v)))
  data)


# part1
(def data (prep-data))
(loop [[n src dst] :in moves]
 (repeat n
     (array/push (data (dec dst))
       (array/pop (data (dec src))))))
(print "Part 1: " (string/from-bytes ;(map |($ 1) (map last data))))


# part2 
(def data (prep-data))
(loop [[n src dst] :in moves]
  (def v @[])
  (repeat n (array/push v (array/pop (data (dec src)))))
  (array/concat (data (dec dst)) (reverse v)))

(print "Part 2: " (string/from-bytes ;(map |($ 1) (map last data))))

