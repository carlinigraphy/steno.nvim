;; Trying in scheme. Can then migrate over to Lua.


(define input (string->list "TKARBG"))

(define (char->code char)
  (case char
    [#\T  1]
    [#\K  2]
    [#\A  3] 
    [#\F  4] 
    [#\R  5] 
    [#\P  6] 
    [#\B  7] 
    [#\L  8] 
    [#\G  9])) 

(define (encode lst)
  (if (null? lst) '()
    (cons (char->code (car lst))
          (encode (cdr lst)))))

(define rules
  '(([1]   . #\T)
    ([2]   . #\K)
    ([2 3] . #\D)
    ([3]   . #\A) 
    ([4]   . #\F) 
    ([5]   . #\R) 
    ([6]   . #\P) 
    ([7]   . #\B) 
    ([6 7] . #\N) 
    ([8]   . #\L) 
    ([9]   . #\G))) 

(define (rule-match match lst)
  (cond
    [(null? match) #t]
    [(null? lst) #f]
    [(eq? (car match)
          (car lst))
     (rule-match (cdr match) (cdr lst))]
    [else #f]))

(define (query rules workspace candidates)
  ())

(query rules '() '())
