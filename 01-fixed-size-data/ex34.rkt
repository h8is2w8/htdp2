;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex34) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 34. Design the function string-first, which extracts the first
; character from a non-empty string. Don’t worry about empty strings.

; String -> 1String
; extracts first character from a non-empty string
; given: "first", expect: "f"
; given: "last", expect: "l"
(define (string-first s)
  (string-ith s 0))