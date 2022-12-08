(use ../utils)
(import janetls)
(def day "04")
(var test? false)

(def infname (string "inputs/day" day "_" (if test? "test" "input") ".txt"))

(janetls/md/digest :md5 "abcdef609043")

(def c (ev/thread-chan 1000))
(def rc (ev/thread-chan 1))

(ev/spawn-thread
  (var x 0)
  (try
    (while (ev/give c x)
      (+= x 1))
    ([err fib] nil)))

(repeat 1
  (ev/spawn-thread
    (while (def x (ev/take c))
      (def dig (janetls/md/digest :md5 (string "bgvyzdsv" x)))
      (if (string/has-prefix? "000000" dig)
        (ev/give rc x)))))


(def part1 (ev/take rc))
(ev/chan-close c)
(ev/chan-close rc)
(print "Part 1:" part1)
