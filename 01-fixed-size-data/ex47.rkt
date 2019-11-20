;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex47) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 47. Design a world program that maintains and displays a “happiness
; gauge.” Let’s call it gauge-prog, and let’s agree that the program
; consumes the maximum level of happiness. The gauge display starts with the
; maximum score, and with each clock tick, happiness decreases by -0.1; it never
; falls below 0, the minimum happiness score. Every time the down arrow key is
; pressed, happiness increases by 1/5; every time the up arrow is pressed,
; happiness jumps by 1/3.

; To show the level of happiness, we use a scene with a solid, red rectangle with
; a black frame. For a happiness level of 0, the red bar should be gone; for the
; maximum happiness level of 100, the bar should go all the way across the scene.

(require 2htdp/universe)

; Constants
(define MIN-HAPPINESS 0)
(define MAX-HAPPINESS 100)
(define HAPPINESS-LOSS-SPEED 0.1)
(define UP_K 1/3)
(define DOWN_K 1/5)


; Graphics
(define BAR-WIDTH 400)
(define BAR-HEIGHT 20)
(define BAR-COLOR "red")
(define BG
  (rectangle BAR-WIDTH BAR-HEIGHT "outline" "black"))


; WorldState is a Number.
; interpretation: cat's hapiness level in percentage terms

; WorldState -> WorldState
; decreases cat's happiness with each tock
(check-expect (tock 100) 99.9)
(check-expect (tock 33.9) 33.8)
(check-expect (tock 0) 0)
(define (tock ws)
  (if (< ws 0.1) 0 (- ws HAPPINESS-LOSS-SPEED)))

; WorldState -> Image
; renders happiness line
(define (render-line ws)
  (rectangle (* BAR-WIDTH (/ ws 100)) BAR-HEIGHT "solid" BAR-COLOR))

; WorldState -> Image
; renders cat's happiness gauge
(define (render ws)
  (place-image/align
   (render-line ws) 0 BAR-HEIGHT "left" "bottom" BG))

; WorldState KeyEvent -> WorldState
; pumps cat's happiness if up or down keys were pressed
(check-expect (pet 50 "enter") 50)
(check-within (pet 50 "up") 66.6 0.1)
(check-expect (pet 50 "down") 60)
(check-expect (pet 0 "up") 0)
(check-expect (pet 0 "down") 0)
(check-expect (pet 100 "up") 100)
(check-expect (pet 100 "down") 100)
(define (pet ws ke)
  (cond
    [(string=? ke "up")
     (min MAX-HAPPINESS (+ ws (* ws UP_K)))]
    [(string=? ke "down")
     (min MAX-HAPPINESS (+ ws (* ws DOWN_K)))]
    [else ws]))

(define (gauge-prog n)
  (big-bang n
    [to-draw render]
    [on-tick tock]
    [on-key pet]))