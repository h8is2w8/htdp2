;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex79) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 79. Create examples for the following data definitions:

; A Color is one of:
; — "white"
; — "yellow"
; — "orange"
; — "green"
; — "red"
; — "blue"
; — "black"
; ex: "red"

; H is a Number between 0 and 100.
; interpretation represents a happiness value
; ex: 5, 50, 99

(define-struct person [fstname lstname male?])
; A Person is a structure:
;   (make-person String String Boolean)
; ex: (make-person "John" "Green" #true)

(define-struct dog [owner name age happiness])
; A Dog is a structure:
;   (make-dog Person String PositiveInteger H)
; interpretation:
;   a dog has owner Person,
;   name String,
;   age PositiveInteger,
;   happiness level H
; ex: (make-dog (make-person ...) "Summer" 5 99)

; A Weapon is one of:
; — #false
; — Posn
; interpretation #false means the missile hasn't
; been fired yet; a Posn means it is in flight
; ex: (make-posn 5 5)
; ex: #false