(use ../utils)
(def day "02")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")))

# 2*l*w + 2*w*h + 2*h*l.
(defn calc [[l w h]]
  (+ (* 2 l w)
     (* 2 w h)
     (* 2 h l)
     (min (* l w) (* w h) (* h l))))

(defn ribbon [[l w h]]
  (+ (* l w h)
     (* 2 (sum (take 2 (sort @[l w h]))))))

(->>
  (map2 scan-number (map (partial string/split "x") input))
  (map ribbon)
  (sum))
