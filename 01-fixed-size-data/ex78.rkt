;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex78) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 78. Provide a structure type and a data definition for representing
; three-letter words. A word consists of lowercase letters, represented with the
; 1Strings "a" through "z" plus #false.

(define-struct three-word [l1 l2 l3])
; three-word is a struct:
;   (make-three-word LCL LCL LCL)
; LCL is one of:
; - 1String [a, z]
; - #false
; interpretation: word consisting of 3 lower case letters or no letter