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

(define (encode str)
  (let loop ([lst (string->list str)] [acc '()])
    (if (null? lst) (reverse acc)
      (loop (cdr lst)
        (cons (char->code (car lst)) acc)))))

(define rules
  '(([1  ] . #\T)
    ([2  ] . #\K)
    ([1 2] . #\D)
    ([3  ] . #\A) 
    ([4  ] . #\F) 
    ([5  ] . #\R) 
    ([6  ] . #\P) 
    ([7  ] . #\B) 
    ([6 7] . #\N) 
    ([8  ] . #\L) 
    ([9  ] . #\G)
    ([7 9] . #\K))) 

(define (rule-match? lst pat)
  (cond
    [(null? lst) #t]
    [(null? pat) #f]
    [(eq? (car lst) (car pat))
     (rule-match? (cdr lst) (cdr pat))]
    [else #f]))

(define (outer stack candidates)
  (if (null? stack) candidates
    (let* ([tail (cdr stack)]
           [head (car stack)]
           [buffer (car head)]
           [input (cdr head)])
      (if (null? input)
        (outer (cdr stack)
          (cons (list->string (reverse buffer))
            candidates))
        (outer (inner rules stack)
          candidates)))))

(define (inner rules stack)
  (let loop ([rules rules]
             [item (car stack)]
             [stack (cdr stack)])
    (if (null? rules) stack
      (let* ([buffer (car item)]
             [input (cdr item)]
             [rule (car rules)]
             [pattern (car rule)]
             [output (cdr rule)])
        (if (rule-match? pattern input)
          (loop (cdr rules) item
            (cons
              (cons (cons output buffer)
                (shift (length pattern) input))
              stack))
          (loop (cdr rules) item stack))))))

(define (shift n lst)
  (if (zero? n) lst
     (shift (sub1 n) (cdr lst))))


(define input
  (encode "TKARBG"))

(format #t
  "~{* ~A\n~}\n"
  (outer
    (list (cons '() input))
    '()))
