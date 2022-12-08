(use ../utils)
(def day "06")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (map string/from-bytes)))

(defn unique [ind]
  (keys (zipcoll ind ind)))

(defn all-unique? [ind]
  (= (length ind) (length (unique ind))))

# Part 1
(print (+ 4 (index-of true (map all-unique? (window 4 input)))))

# Part 2
(print (+ 14 (index-of true (map all-unique? (window 14 input)))))
