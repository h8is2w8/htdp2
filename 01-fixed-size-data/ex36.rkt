;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex36) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 36. Design the function image-area, which counts the number of pixels
; in a given image.

(require 2htdp/image)

; Image -> Number
; counts number of pixels in a given image
; given: (empty-scene 100 100), expect: 10000
(define (image-area img)
  (* (image-width img) (image-height img)))