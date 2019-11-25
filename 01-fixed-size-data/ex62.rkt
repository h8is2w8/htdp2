;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex62) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 58. Introduce constant definitions that separate the intervals for low
; prices and luxury prices from the others so that the legislators in Tax Land can
; easily raise the taxes even more.

; Sample Problem: Design a world program that simulates the working of a door
; with an automatic door closer. If this kind of door is locked, you can unlock it
; with a key. An unlocked door is closed, but someone pushing at the door opens it.
; Once the person has passed through the door and lets go, the automatic door takes
; over and closes the door again. When a door is closed, it can be locked again.

(require 2htdp/image)
(require 2htdp/universe)

(define LOCKED "locked") ; A DoorState is one of:
(define CLOSED "closed") ; – LOCKED
(define OPEN "open")     ; – CLOSED
                         ; – OPEN

; DoorState -> DoorState
; closes an open door over the period of one tick
(check-expect (door-closer LOCKED) LOCKED)
(check-expect (door-closer CLOSED) CLOSED)
(check-expect (door-closer OPEN) CLOSED)
(define (door-closer state-of-door)
  (cond
    [(string=? state-of-door LOCKED) LOCKED]
    [(string=? state-of-door CLOSED) CLOSED]
    [(string=? state-of-door OPEN) CLOSED]))

; DoorState, KeyEvent -> DoorState
; turns key event k into an action on state s
(check-expect (door-action LOCKED "u") CLOSED)
(check-expect (door-action CLOSED "l") LOCKED)
(check-expect (door-action CLOSED " ") OPEN)
(check-expect (door-action OPEN "a") OPEN)
(define (door-action s k)
  (cond
    [(and (string=? LOCKED s) (string=? "u" k)) CLOSED]
    [(and (string=? CLOSED s) (string=? "l" k)) LOCKED]
    [(and (string=? CLOSED s) (string=? " " k)) OPEN]
    [else s]))

; DoorState -> Image
; translates the state s into a large text image
(check-expect (door-render CLOSED)
              (text CLOSED 40 "red"))
(define (door-render s)
  (text s 40 "red"))

; DoorState -> DoorState
; simulates a door with an automatic door closer
(define (door-simulation initial-state)
  (big-bang initial-state
    [on-tick door-closer 3]
    [on-key door-action]
    [to-draw door-render]))
