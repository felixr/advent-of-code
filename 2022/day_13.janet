(use ../utils)
(def day "13")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def grammar 
  ~{
    :value (choice (cmt (<- (some :d)) ,scan-number) :list)
    :list (group (choice "[]" (* "[" :value (any (* "," :value)) "]")))
    :main :list}) 

# (peg/match grammar "[1,[2,[3,[4,[5,6,0]]]],8,9]")

(def raw-input
  (->>
   (slurp infname)
   (string/trim)
   (string/split "\n\n")
   (map (partial string/split "\n"))))

(def input (map2 |(first (peg/match grammar $)) raw-input))

(defn in-order? [a b]
  (cond
    (and (number? a) (number? b)) (if (= a b) nil (< a b))
    (and (array? a) (array? b)) 
    (cond
      (and (empty? a) (not (empty? b))) true
      (and (empty? b) (not (empty? a))) false 
      (and (empty? a) (empty? b)) nil
      (let [fsta (first a)
            fstb (first b)
            newa (array ;(drop 1 a))
            newb (array ;(drop 1 b))
            inorder (in-order? fsta fstb)]
           (if (nil? inorder)
             (in-order? newa newb)
             inorder)))
    (and (number? a) (array? b)) (in-order? @[a] b)
    (and (number? b) (array? a)) (in-order? a @[b])))
                                 
(defn part1 []
  (def indices @[])
  (loop [[idx pair] :in (enumerate input)]
    # (def res ((trace in-order?) ;pair))
    (def res (in-order? ;pair))
    (if res (array/push indices (inc idx))))
    #(print "##### " res))

  (print "Part 1: " (sum indices)))
(part1)

(defn part2 []
  (def input2 (mapcat identity input))
  (array/push input2 @[@[2]])
  (array/push input2 @[@[6]])

  (def res (sort input2 in-order?))
  (def x (inc (find-index (partial = "@[@[2]]") (map (partial string/format "%q") res))))
  (def y (inc (find-index (partial = "@[@[6]]") (map (partial string/format "%q") res))))
  (print "Part 2: " (* x y)))
(part2)

  
