#lang typed/racket

(: equal? (All (A) (case->
           [-> Integer    Integer    Boolean]
           [-> String     String     Boolean]
           [-> (Listof A) (Listof A) Boolean])))
(define (equal? a b)
  (cond [(and (integer? a)
              (integer? b)) (= a b)]
        [(and (string?  a)
              (string?  b)) (string=? a b)]
        [(and (list?    a)
              (list?    b)) (for/and ([a* a] [b* b]) (equal? a* b*))]))

(equal? 1 1)
(equal? "a" "a")
(equal? (list 1 2 3) (list 1 2 3))

(equal? 1 2)
(equal? "a" "b")
(equal? (list 1 2 3) (list 1 2 4))

;; (equal? 'a 'a)
