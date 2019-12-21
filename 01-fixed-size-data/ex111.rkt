;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex111) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define-struct vec [x y])
; A vec is
;   (make-vec PositiveNumber PositiveNumber)
; interpretation represents a velocity vector

; Any -> Vec
; creates a vector with coord x y,
; if x & y are positive numbers
(define (checked-make-vec x y)
  (if (and (number? x) (positive? x))
      (if (and (number? y) (positive? y))
          (make-vec x y)
          (error "checked-make-vec: y should be positive number"))
      (error "checked-make-vec: x should be positive number")))



(define (demo args errors)
  (cond
    [(> (length args) 0)
     (if (and (number? (cadar args))
              (positive? (cadar args)))
         (demo (cdr args) errors)
         (demo (cdr args) (cons (caar args) errors)))
     ]
    [else
     (if (> (length errors) 0)
         (error errors)
         (make-vec 5 5))]))
              
(define (format-errors errors)
  