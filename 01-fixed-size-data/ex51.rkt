;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex51) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 51. Design a big-bang program that simulates a traffic light for a
; given duration. The program renders the state of a traffic light as a solid
; circle of the appropriate color, and it changes state on every clock tick. What
; is the most appropriate initial state? Ask your engineering friends.

(require 2htdp/image)
(require 2htdp/universe)

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent all 
; possible states that a traffic light may assume 

; TrafficLight -> TrafficLight
; yields the next state, given current cs
(check-expect (tl-next "green") "yellow")
(check-expect (tl-next "yellow") "red")
(check-expect (tl-next "red") "green")
(define (tl-next cs)
  (cond
    [(string=? cs "green") "yellow"]
    [(string=? cs "yellow") "red"]
    [(string=? cs "red") "green"]))

; TrafficLight -> Image
; renders the current state cs as an image
(define (tl-render cs)
  (overlay (rectangle 80 30 "outline" "black")
           (beside (tl-render-bulb "green" cs)
                   (tl-render-bulb "yellow" cs)
                   (tl-render-bulb "red" cs))))

; Color, TrafficLight -> Image
; renders light bulb from color and current state as an image
; if current state matches with bulb's color, bulb is rendered lightened
(define (tl-render-bulb cs color)
  (circle 10 (if (string=? cs color) "solid" "outline") color))

; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1]))

