;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex44) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Sample Problem Design a program that moves a car from left to right on the world
; canvas, three pixels per clock tick.

(require 2htdp/universe)

; A AnimationState is a Number.
; interpretation: the number of clock ticks
; since the animation started

(define WIDTH-OF-WORLD 720)
(define HEIGHT-OF-WORLD 40)
 
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
(define CAR-LENGTH (+ WHEEL-DISTANCE (* WHEEL-RADIUS 4)))
(define CAR-HEIGHT (* WHEEL-RADIUS 4))
(define CAR-CENTER (/ CAR-LENGTH 2))
(define CAR-SPEED 2)

(define WHEEL (circle WHEEL-RADIUS "solid" "black"))

(define SPACE (rectangle WHEEL-DISTANCE 0 "solid" "red"))

(define BOTH-WHEELS (beside WHEEL SPACE WHEEL))

(define CAR-BODY
  (above (rectangle (/ CAR-LENGTH 2) (/ CAR-HEIGHT 2) "solid" "red")
         (rectangle CAR-LENGTH (/ CAR-HEIGHT 2) "solid" "red")))

(define CAR (underlay/xy CAR-BODY (- (/ (- CAR-LENGTH WHEEL-DISTANCE) 2) (* WHEEL-RADIUS 2))
                         (- CAR-HEIGHT WHEEL-RADIUS) BOTH-WHEELS))

(define TREE
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

(define Y-CAR (- HEIGHT-OF-WORLD (/ (image-height CAR) 2)))
(define Y-TREE (- HEIGHT-OF-WORLD (/ (image-height TREE) 2)))

(define BACKGROUND (place-images (list TREE TREE TREE)
                                 (list (make-posn (/ WIDTH-OF-WORLD 3) Y-TREE)
                                       (make-posn (/ WIDTH-OF-WORLD 2) Y-TREE)
                                       (make-posn (/ WIDTH-OF-WORLD 1.5) Y-TREE))
                                (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD)))


; Radians -> Degrees
; converts radians to degrees
(check-within (radians->degrees 1) 0.017 0.001)
(define (radians->degrees x)
  (* x (/ pi 180)))


; AnimationState -> Number
; calc car's y position
; (check-expect (car-y-pos 0) 20)
(define (car-y-pos ws)
  (- Y-CAR (/ (* (+ 1 (sin (radians->degrees ws)))
                 (- HEIGHT-OF-WORLD (image-height CAR))) 2)))


; AnimationState -> Image
; places the image of a car x pixels from 
; the left margin of the BACKGROUND scene,
; according to the given state
(define (render ws)
  (place-image CAR (- ws CAR-CENTER) (car-y-pos ws) BACKGROUND))


; AnimationState -> AnimationState
; moves a car for every clock tick
(check-expect (tock  53) (+ 53 CAR-SPEED))
(check-expect (tock  70) (+ 70 CAR-SPEED))
(define (tock ws)
  (if (>= (- ws CAR-CENTER) WIDTH-OF-WORLD) 0 (+ ws CAR-SPEED)))


; AnimationState -> Boolean
; check if a car is outside of the world
(check-expect (end? 0) #false)
(check-expect (end? 100) #false)
(check-expect (end? 750) #true)
(define (end? ws)
  (>= ws (+ WIDTH-OF-WORLD CAR-CENTER)))

; WorldState Number Number MouseEvent -> WorldState
; places the car at x-mouse
; if the given me is "button-down" 
(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? me "button-down") x-mouse]
    [else x-position-of-car]))


; AnimationState -> AnimationState
; launches the program from some initial state
; run: (main 0)
(define (main ws)
  (big-bang ws
    [on-tick tock]
    [on-mouse hyper]
    [to-draw render]))
