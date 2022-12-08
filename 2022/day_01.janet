(def elves @[])
(def inp (map scan-number (string/split "\n" (slurp "inputs/day01_input.txt"))))

(defn where [pred ind]
  (seq [i :range [0 (length ind)] :when (pred (ind i))] i))


(defn window [ind n]
  (seq [i :range [0 (- (length ind) n)]] 
   (map |(ind $) (range i (+ i n)))))    


(def partitioned
  (map |(array/slice inp (+ 1 (0 $)) (1 $))
    (window (array/push (array/insert (where nil? inp) -1 nil) nil) 2)))

(def sums (map sum partitioned))
(sum (take 3 (sort sums >)))
(where |(= $ (max ;sums)) sums)

(defn map2 [f ind]
  (map (partial map f) ind))

(def inp (as->
           (slurp "inputs/day01_input.txt") _
           (string/trim _)
           (string/split "\n\n" _)
           (map (partial string/split "\n") _)
           (map (partial map scan-number) _)
           (map sum _)
           (sort _ >)
           (take 3 _)))
           
  


