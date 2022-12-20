(def day "20")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)
    (string/split "\n")
    (map scan-number)))

(defn move [lst idx moves]
  (def tmp (lst idx))
  (def dst (mod (+ idx moves) (dec (length lst))))
  (array/remove lst idx)
  (array/insert lst dst tmp))

(defn process [idxs vals]
  (loop [i :range [0 (length idxs)]
         :let [idx (index-of i idxs)
               val (vals i)]
         :when (not= 0 val)]
    (move idxs idx val)))

(let [vals input
      idxs (range (length input))
      _ (process idxs vals)
      val-idx (index-of 0 vals)
      zidx (index-of val-idx idxs)]
  # 1087
  (print "Part1: "
         (sum (seq [i :in [1000 2000 3000]]
                (vals (idxs (mod (+ zidx i) (length idxs))))))))

(let [ovals input
      vals (map |(* 811589153 $) input)
      idxs (range (length input))
      _ (repeat 10 (process idxs vals))
      val-idx (index-of 0 vals)
      zidx (index-of val-idx idxs)]
  # 13084440324666
  (print "Part2: " (* 811589153
                      (sum (seq [i :in [1000 2000 3000]]
                             (ovals (idxs (mod (+ zidx i) (length idxs)))))))))
