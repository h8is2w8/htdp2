;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex35) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 35. Design the function string-last, which extracts the last character
; from a non-empty string.

; String -> 1String
; extracts the last character from a non-empty string
; given: "first", expect: "t"
; given: "cons", expect: "s"
(define (string-last s)
  (string-ith s (- (string-length s) 1)))