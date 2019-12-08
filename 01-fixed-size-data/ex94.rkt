;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex94) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 94. Draw some sketches of what the game scenery looks like at various
; stages. Use the sketches to determine the constant and the variable pieces of
; the game. For the former, develop physical and graphical constants that describe
; the dimensions of the world (canvas) and its objects. Also develop some
; background scenery. Finally, create your initial scene from the constants for
; the tank, the UFO, and the background.

(define WIDTH 200)
(define HEIGHT 200)

(define UFO
  (overlay (circle 5 "solid" "green")
           (rectangle 20 5 "solid" "green")))

(define TANK
  (rectangle 30 15 "solid" "blue"))

(define MISSILE (triangle 12 "solid" "red"))

(define BACKGROUND
  (empty-scene WIDTH HEIGHT))

(define CENTER (/ WIDTH 2))
(define TANK-Y
  (- HEIGHT (/ (image-height TANK) 2)))

(define SCENE
  (place-image UFO CENTER 20
   (place-image TANK CENTER TANK-Y BACKGROUND)))
   