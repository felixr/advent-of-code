(import re [findall])
(require hyrule.argmove [->>])

(with [f (open "inputs/day15_input.txt" "r")]
  (setv lines (.readlines f)))

(defn tpl->pts [nums]
  (let [[a b c d] (lfor p nums (int p))]
    [[a b] [c d]]))

(setv data (lfor l lines (tpl->pts (findall "[-]?[0-9]+" l))))

(defn manhattan [pt1 pt2]
  (let [[a b] pt1
        [x y] pt2]
    (+ (abs (- a x)) (abs (- b y)))))


(defn in-reach-of? [pt sens beac]
  (let [reach (manhattan sens beac)
        dist (manhattan sens pt)]
    (<= dist reach)))


(defn in-reach? [p]
  (for [[sens beac] data]
    (when (in-reach-of? p sens beac)
      (return True))))

(defn add2 [a b]
  [(+ (get a 0) (get b 0)) (+ (get a 1) (get b 1))])


(defn border [pt d]
  (for [dx (range 0 (+ 1 d))
        dy [(- d dx) (- dx d)]]
    (yield (add2 pt [dx dy]))))

(for [[sens beac] data]
  (let [mh (manhattan sens beac)]
    (for [[x y] (border sens (+ 1 mh))]
      (when (and
              (<= 0 (min x y))
              (<= (max x y) 4000000))
        (when (not (in-reach? [x y]))
          (print f"x={x}, y={y}, score={(+ y (* x 4000000))}")
          (exit))))))
