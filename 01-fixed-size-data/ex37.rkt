;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex37) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 37. Design the function string-rest, which produces a string like the
; given one with the first character removed.

; String -> String
; produces string like the given one with the first character removed
; given: "zzero", expect: "zero"
(define (string-rest s)
  (substring s 1 (string-length s)))