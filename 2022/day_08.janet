(use ../utils)
(def day "08")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
   (slurp infname)
   (string/trim)
   (string/split "\n")
   (map values)
   (map2 string/from-bytes)
   (map2 scan-number)))

(def nrow (length input))
(def ncol (length (first input)))


(def grid @{})
(loop [x :range [0 ncol]
       y :range [0 nrow]]
    (set (grid [x y]) (get-in input [y x])))

(def mgrid @{})

(loop [i :range [0 nrow]]
  (set (mgrid [0 i]) 1)
  (set (mgrid [(dec ncol) i]) 1))

(loop [i :range [0 ncol]]
 (set (mgrid [i 0]) 1)
 (set (mgrid [i (dec nrow)]) 1))

(defn line [[x y] dir]
  (match dir
    0 (map |(grid [$ y]) (range 0 x))
    1 (map |(grid [$ y]) (range (inc x) ncol))
    2 (map |(grid [x $]) (range 0 y))
    3 (map |(grid [x $]) (range (inc y) nrow))))

(loop [x :range [1 (dec ncol)]
       y :range [1 (dec nrow)]]
 (def cur (grid [x y]))
 (def mxs (map |(max ;$) 
            (filter truthy?
              [(line [x y] 0)
               (line [x y] 1)
               (line [x y] 2)
               (line [x y] 3)])))
 (if (< (min ;mxs) cur)
   (set (mgrid [x y]) 1)))

(defn ntree [h ln]
 (inc (or (index-of true (map |(>= $ h) ln)) 
         (dec (length ln)))))

(defn scenic [pt]
 (def cur (grid pt))
 (def l (ntree cur (reverse (line pt 0))))
 (def r (ntree cur (line pt 1)))
 (def u (ntree cur (reverse (line pt 2))))
 (def d (ntree cur (line pt 3)))
 (* l r u d))


(defn hgt [[x y]]
  (get-in input [y x]))
        
(comment (loop [y :range [0 nrow]])
       (print (string/join 
                (map |(if (mgrid [$ y]) 
                        (string "\e[32m" (hgt [$ y]) "\e[39m") 
                        (string (hgt [$ y])))
                    (range ncol)))))

(print "Part 1:" (length mgrid))
(print "Part 2:" 
       (max ;(seq [x :range [1 (dec ncol)]
                   y :range [1 (dec nrow)]]
               (scenic [x y]))))

