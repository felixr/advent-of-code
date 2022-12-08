(def day "01")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (map |(if (= (chr "(") $) 1 -1))))

(sum input)

(var floor 0)
(loop [[v i] :in (map tuple input (range 1 (length input)))]
  (+= floor v)
  (print floor)
  (when (= floor -1)
    (print i)
    (break)))
