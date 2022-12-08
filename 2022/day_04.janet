(use ../utils)

(def syntax 
  '{
    :dig (range "09")
    :num (some :dig)
    :range (sequence (<- :num) "-" (<- :num))
    :main (sequence :range "," :range)})


(defn full-overlap? [[a b x y]]
 (or 
   (and (>= a x) (<= b y))
   (and (>= x a) (<= y b))))

(defn overlap? [[a b x y]]
 (or
   (between? y a b)
   (between? b x y)))

(def inp (->> (slurp "inputs/day04_input.txt")
           (string/trim)
           (string/split "\n")
           (map (partial peg/match syntax))
           (map2 scan-number)))

(print "Part 1: " (->> inp (keep full-overlap?) (length)))
(print "Part 2: " (->> inp (keep overlap?) (length)))
   
              
(->> (slurp "inputs/day04_input.txt")
   (string/trim)
   (string/split "\n")
   (map (partial peg/match syntax))
   (map2 scan-number)
   (dup)
   ((tfun
      |(keep full-overlap? $) 
      |(keep overlap? $)))
   (map length))
   
   
