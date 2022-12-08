(defn map2 [f ind]
  (map (partial map f) ind))

#(map2 inc [[1 2] [3 4]])


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
