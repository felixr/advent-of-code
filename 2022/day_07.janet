(use ../utils)
(def day "07")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def size-limit 100000)
(def req 30000000)
(def disk 70000000)

(def input
  (->>
   (slurp infname)
   (string/trim)
   (string/split "\n")
   (map (partial string/split " "))))

(def ds @["."])
(def files @[])
(defn add-file [d n sz]
  (while (not (empty? d))
    (array/push files [(string/join d "/") n sz])
    (array/pop d)))
    
  
(loop [cmd :in (drop 1 input)]
  (match cmd 
    ["$" "cd" ".."] (array/pop ds)
    ["$" "cd" d] (array/push ds d)
    ["$" "ls" ] nil
    ["dir" _] nil
    [n f] (add-file (array/slice ds) f (scan-number n))))

(->> (pairs (group-by first files))
   (map (fn [[d fs]] [d (sum (map |(last $) fs))]))
   (map last)
   (filter (partial > size-limit))
   (sum))

(def sizes (->> (pairs (group-by first files))
             (map (fn [[d fs]] [d (sum (map |(last $) fs))]))))

(def thresh (- req (- disk (last (last (filter |(= (first $) ".") sizes))))))

(filter (partial < thresh) (sort (map last sizes)))
   
   
  
