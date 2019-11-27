;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex82) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 82. Design the function cmp-word. The function consumes two
; three-letter words (see exercise 78). It produces a word that indicates where
; the given ones agree and disagree. The function retains the content of the
; structure fields if the two agree; otherwise it places #false in the field of
; the resulting word. Hint The exercises mentions two tasks: the comparison of
; words and the comparison of “letters.”

(define-struct three-word [l1 l2 l3])
; three-word is a struct:
;   (make-three-word LCL LCL LCL)
; LCL is one of:
; - 1String [a, z]
; - #false
; interpretation: word consisting of 3 lower case letters or no letter

; three-word three-word -> three-word
; returns first three-word if match otherwise
; returns a new three-word with #false in mismatched fields
(check-expect (cmp-three-word (make-three-word "x" "y" "z")
                              (make-three-word "x" "y" "z"))
              (make-three-word "x" "y" "z"))
(check-expect (cmp-three-word (make-three-word "x" "y" "z")
                              (make-three-word "x" "y" "m"))
              (make-three-word "x" "y" #false))                          
(define (cmp-three-word w1 w2)
  (make-three-word
   (cmp-letter (three-word-l1 w1) (three-word-l1 w2))
   (cmp-letter (three-word-l2 w1) (three-word-l2 w2))
   (cmp-letter (three-word-l3 w1) (three-word-l3 w2))))

; LCL LCL -> LCL
; returns first LCL if match otherwise #false 
(check-expect (cmp-letter "L" "L") "L")
(check-expect (cmp-letter "L" "X") #false)
(check-expect (cmp-letter "L" #false) #false)
(check-expect (cmp-letter #false "X") #false)
(check-expect (cmp-letter #false #false) #false)
(define (cmp-letter l1 l2)
  (cond
    [(and (string? l1) (string? l2))
     (if (string=? l1 l2) l1 #false)]
    [else #false]))