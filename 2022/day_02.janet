(defn rps [s]
  (match s
    "A" :rock
    "B" :paper
    "C" :scissors
    "X" :rock
    "Y" :paper
    "Z" :scissors))

(defn win [tpl]
  (match tpl
    ([a b] (= a b)) 3
    [:rock :paper] 6
    [:rock :scissors] 0
    [:paper :rock] 0
    [:paper :scissors] 6
    [:scissors :paper] 0
    [:scissors :rock] 6))

(defn score [tpl]
  (def s1 (match (1 tpl)
            :rock 1
            :paper 2
            :scissors 3))
  (+ s1 (win tpl)))

(print "Part 1: "
       (->> (slurp "inputs/day02_input.txt")
            (string/trim)
            (string/split "\n")
            (map (partial string/split " "))
            (map (partial map rps))
            (map score)
            (sum)))

(defn ldw [s]
  (match s
    "X" :lose
    "Y" :draw
    "Z" :win))

(defn solve [tpl]
  (match tpl
    [_ :draw] (first tpl)
    [:rock :lose] :scissors
    [:rock :win] :paper
    [:paper :lose] :rock
    [:paper :win] :scissors
    [:scissors :lose] :paper
    [:scissors :win] :rock))

(defn zipf [& cols]
  (interleave ;cols))

(zipf [inc dec] [1 2])

(print "Part 2: "
       (->> (slurp "inputs/day02_input.txt")
            (string/trim)
            (string/split "\n")
            (map (partial string/split " "))
            (map (juxt (comp rps first) (comp ldw last)))
            (map (juxt first solve))
            (map score)
            (sum)))
