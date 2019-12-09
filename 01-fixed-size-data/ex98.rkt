;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex98) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 98. Design the function si-game-over? for use as the stop-when handler.
; The game stops if the UFO lands or if the missile hits the UFO. For both
; conditions, we recommend that you check for proximity of one object to another.

(require 2htdp/universe)

; Constants

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

(define UFO-H (image-height UFO))
(define UFO-W (image-width UFO))
(define MISSILE-H (image-height MISSILE))
(define MISSILE-W (image-width MISSILE))


; Structures

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)

(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick

; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])


; Rendering

; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game

; SIGS -> Image
; adds TANK, UFO, and possibly MISSLE to
; the BACKGROUND scene
(define (si-render s)
  (cond
    [(aim? s)
     (tank-render (aim-tank s)
                  (ufo-render (aim-ufo s) BACKGROUND))]
    [(fired? s)
     (tank-render
      (fired-tank s)
      (ufo-render (fired-ufo s)
                  (missile-render (fired-missile s)
                                 BACKGROUND)))]))

; Tank Image -> Image
; adds t to the give image im
(define (tank-render t im)
  (place-image TANK (tank-loc t) TANK-Y im))

; UFO Image -> Image
; adds u to the given image im
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

; MISSLE Image -> Image
; adds m to the given image im
(define (missile-render m im)
  (place-image MISSILE (posn-x m) (posn-y m) im))

; SIGS -> Bool
; checks if the UFO lands or if the missile hits the UFO
;
; MISSILE hasn't been sent yet and UFO landed
(check-expect (si-game-over? (make-aim (make-posn 50 HEIGHT)
                                       (make-tank 60 4))) #true)
; MISSILE has been sent but UFO landed
(check-expect (si-game-over? (make-fired (make-posn 60 HEIGHT)
                                         (make-tank 60 4)
                                         (make-posn 30 30))) #true)
; MISSILE hasn't been sent yet and UFO is still landing
(check-expect (si-game-over? (make-aim (make-posn 50 10)
                                       (make-tank 60 4))) #false)
; MISSILE has been sent but hasn't hit UFO yet
(check-expect (si-game-over? (make-fired (make-posn 60 20)
                                         (make-tank 60 4)
                                         (make-posn 30 30))) #false)
; MISSILE hit UFO
(check-expect (si-game-over? (make-fired (make-posn 60 20)
                                         (make-tank 60 4)
                                         (make-posn 60 20))) #true)
(define (si-game-over? s)
  (cond
    [(aim? s) (ufo-landed? (aim-ufo s))]
    [(fired? s)
     (or
      (ufo-landed? (fired-ufo s))
      (ufo-hit? (fired-missile s)
                (fired-ufo s)))]))

; UFO -> Bool
; returns true if u reaches bottom of the scene
(check-expect (ufo-landed? (make-posn 50 HEIGHT)) #true)
(check-expect (ufo-landed? (make-posn 15 50)) #false)
(define (ufo-landed? u)
  (>= (posn-y u) HEIGHT))

; UFO MISSILE -> Bool
; check if m collides with u
; MISSILE collides at the right-left side
(check-expect (ufo-hit? (make-posn 15 50) (make-posn 30 50)) #true)
; MISSILE doesn't collide at the right-left side
(check-expect (ufo-hit? (make-posn 14 50) (make-posn 30 50)) #false)
; MISSILE collided at the left-right side
(check-expect (ufo-hit? (make-posn 45 49) (make-posn 30 50)) #true)
; MISSILE doesn't collide at the left-right side
(check-expect (ufo-hit? (make-posn 46 50) (make-posn 30 50)) #false)
; MISSILE collided at the center
(check-expect (ufo-hit? (make-posn 30 50) (make-posn 30 50)) #true)
; MISSILE doesn't collide at the center
(check-expect (ufo-hit? (make-posn 30 35) (make-posn 30 50)) #false)
(define (ufo-hit? m u)
  (and
   (> (+ (posn-x m) (/ MISSILE-W 2)) (- (posn-x u) (/ UFO-W 2)))
   (< (- (posn-x m) (/ MISSILE-W 2)) (+ (posn-x u) (/ UFO-W 2)))
   (> (+ (posn-y m) (/ MISSILE-H 2)) (- (posn-y u) (/ UFO-H 2)))
   (< (- (posn-y m) (/ MISSILE-H 2)) (+ (posn-y u) (/ UFO-H 2)))))


; SIGS -> Image
(define (si-render-final s)
  (overlay (text "GAME OVER" 24 "red")
           (si-render s)))
