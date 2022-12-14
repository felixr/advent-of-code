(defn map2 [f ind]
  (map (partial map f) ind))

(defn rep [v]
  (coro (forever (yield v))))

(defn ones []
  (rep 1))

(defn zip
  [& rest]
  (fiber/new
    (fn []
      (var k (map next rest))
      (while (every? k)
        (yield (seq [i :range [0 (length rest)]]
                 (in (in rest i) (in k i))))
        (set k (seq [i :range [0 (length rest)]]
                 (next (in rest i) (in k i))))))))

(defn window [n ds]
  (coro
    (var k (next ds))
    (var win @[])
    (loop [:repeat n]
      (array/push win (in ds k))
      (set k (next ds k)))
    (yield win)
    (while (not= k nil)
      (set win (array/slice win 1))
      (array/push win (in ds k))
      (yield win)
      (set k (next ds k)))
    win))

(defn chain
  "Chain multiple fibers or data structures together"
  [& fbrs]
  (coro
    (loop [fb :in fbrs]
      (var k (next fb))
      (while (not= k nil)
        (yield (in fb k))
        (set k (next fb k))))))


(defn between? [x a b]
  "Is x between a and b (including a b)"
  (and (>= x a) (<= x b)))

(defn tfun
  "Applies a list of function to the respective elements in a tuple"
  [& funs]
  (fn [ind]
    (map (fn [f v] (f v)) funs ind)))

(defn swapf
  "Swaps the arguments of a 2-argument function"
  [f]
  (fn [a b] (f b a)))

(defn dup [a] [a a])


(defn split
  "Splits an indexable data structure into n arrays. Taking every n-th element."
  [n ind]
  (def out @[])
  (repeat n (array/push out @[]))
  (loop [i :range [0 (length ind)]]
    (array/push
      (out (% i n))
      (ind i)))
  out)

(defn unique
  "Returns the unique elements of a data structure."
  [ind]
  (keys (zipcoll ind ind)))

(defn enumerate
  "Returns (idx value) tuples for each value in the data structure"
  [ind]
  (map tuple (range 0 (length ind)) ind))

(defn grid->xpm [g colors]
  (let
    [rows (map first (keys g))
     cols (map last (keys g))
     min-row (min-of rows)
     max-row (max-of rows)
     min-col (min-of cols)
     max-col (max-of cols)]
    (print "/* XPM */\nstatic char * image[] = {")
    (print "\"" (- max-col min-col) " " (- max-row min-row) " " 3 " " 1 "\",")
    (eachp [ch hex] colors
      (printf "\"%s c %s\"," ch hex))
    (loop [r :range [min-row (inc max-row)]]
      (print "\""
             (string ;(map |(or (get g [r $]) ".")
                           (range min-col (inc max-col))))
             "\","))
    (print "};")))
