(use ../utils)
(def day "11")
(var test? true)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(def input
  (->>
    (slurp infname)
    (string/trim)))

(def grammar
  ~{:lb (set "\n\r")
    :char (range " z")
    :number (cmt (<- (some :d)) ,scan-number)
    :header (* "Monkey " :number ":" :lb)
    :items (* "  Starting items: " :number (any (* ", " :number)) "\n")
    :op (* "  Operation: new = old " (<- (set "*+")) " " (<- (some :char)) "\n")
    :test (* "  Test: divisible by " :number "\n")
    :true (* "    If true: throw to monkey " :number "\n")
    :false (* "    If false: throw to monkey " :number (? "\n"))
    :line (<- (* (some (range " z")) :lb))
    :record (group (* :header
                      (group :items)
                      (group :op)
                      :test
                      :true
                      :false))
    :main (* :record (some (* :lb :record)))})

(def monkeys (map (fn [[idx data op test t f]]
                    @{:idx idx :data data :op op :test test :t t :f f :cnt 0})
                  (peg/match grammar input)))


(repeat 20
  (each m monkeys
    (each item (m :data)
      (def new
        (match (m :op)
          ["*" "old"] (* item item)
          ["*" n] (* item (scan-number n))
          ["+" n] (+ item (scan-number n))))
      (put m :cnt (inc (m :cnt)))
      (def new2 (math/floor (/ new 3)))
      (if (= 0 (mod new2 (m :test)))
        (array/push ((monkeys (m :t)) :data) new2)
        (array/push ((monkeys (m :f)) :data) new2)))
    (array/clear (m :data))))

(print "Part1: " (* ;(map |($ :cnt) (take 2 (sort monkeys (fn [a b] (> (a :cnt) (b :cnt))))))))


(def monkeys (map (fn [[idx data op test t f]]
                    @{:idx idx :data data :op op :test test :t t :f f :cnt 0})
                  (peg/match grammar input)))

(defn print-monkeys [i]
  (print "### " i)
  (each m monkeys
    (printf "%d: %d" (m :idx) (m :cnt))))

(def lcm (* ;(map |($ :test) monkeys)))

(for i 1 10001
  (each m monkeys
    (each item (m :data)
      (def new
        (match (m :op)
          ["*" "old"] (* item item)
          ["*" n] (* item (scan-number n))
          ["+" n] (+ item (scan-number n))))
      (put m :cnt (inc (m :cnt)))
      (if (= 0 (mod new (m :test)))
        (array/push ((monkeys (m :t)) :data) (mod new lcm))
        (array/push ((monkeys (m :f)) :data) (mod new lcm))))
    (array/clear (m :data)))
  (if (in @{1 0 20 0 1000 0} i)
    (print-monkeys i)))


(print "Part2: " (* ;(map |($ :cnt) (take 2 (sort monkeys (fn [a b] (> (a :cnt) (b :cnt))))))))
