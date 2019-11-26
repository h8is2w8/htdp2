;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex77) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 77. Provide a structure type definition and a data definition for
; representing points in time since midnight. A point in time consists of three
; numbers: hours, minutes, and seconds.

(define-struct time-pt [hh mm ss])
; time-pt is a struct:
;   (make-time-pt Number Number Number)
; interpreation: (make-time-pt hh mm ss) is a time since midnight:
; hh Number [0, 24)
; mm Number [0, 60)
; ss Number [0, 60)