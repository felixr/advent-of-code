(use ../utils)
(def day "21")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def grammar
  ~{:number (cmt (<- (some :d)) ,scan-number)
    :op (<- (set "+-/*"))
    :operation (group (* :name " " :op " " :name))
    :name (<- (repeat 4 :a))
    :main (* :name ": " (choice :number :operation))})

(def input
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")
    (map (partial peg/match grammar))))


(defn op2f [op]
  (match op "+" + "-" - "*" * "/" /))

(defn solve [tbl name]
  (def v (get tbl name))
  (if (number? v)
    v
    (let [[a op b] v
          av (solve tbl a)
          bv (solve tbl b)
          res ((op2f op) av bv)]
      (put tbl name res)
      res)))

(defn part1 []
  (def tbl (from-pairs input))
  (print "Part 1: " (solve tbl "root")))
(part1)


(def tbl (from-pairs input))
(def [left _ right] (get tbl "root"))
(def target (solve tbl right))

(defn solve-with [atbl name val]
  (def tbl (table/clone atbl))
  (put tbl "humn" val)
  (solve tbl name))

(var val 1)
(while (pos? (solve-with tbl left val))
  (*= val 10))

(var order (/ val 10))
(var humn 0)

(while (>= order 1)
  (var i 9)
  (while (> i 0)
    (def new (+ (* order i) humn))
    (put tbl "humn" new)
    (def res (solve (table/clone tbl) left))
    (if (< (solve-with tbl left new) target)
      (-= i 1)
      (do
        (set order (/ order 10))
        (set humn new)
        (set i 0)))))
(print "Part 2: " humn)
# Part 2: 3349136384441

