;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 4.4-ufo) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A WorldState is a Number.
; interpretation number of pixels between the top and the UFO
;
; A WorldState falls into one of three intervals: 
; – between 0 and CLOSE
; – between CLOSE and HEIGHT
; – below HEIGHT
 
(define WIDTH 300) ; distances in terms of pixels 
(define HEIGHT 100)
(define CLOSE (/ HEIGHT 3))
(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO (overlay (circle 10 "solid" "green")
                     (rectangle 30 5 "solid" "violet")))
(define UFO-CENTER (/ WIDTH 2))
 
; WorldState -> WorldState
(define (main y0)
  (big-bang y0
     [on-tick nxt]
     [to-draw render/status]))
 
; WorldState -> WorldState
; computes next location of UFO 
(check-expect (nxt 11) 14)
(define (nxt y)
  (+ y 3))
 
; WorldState -> Image
; places UFO at given height into the center of MTSCN
(check-expect (render 11) (place-image UFO UFO-CENTER 11 MTSCN))
(define (render y)
  (place-image UFO UFO-CENTER y MTSCN))


; WorldState -> Image
; adds a status line to the scene created by render

(check-expect (render/status 10)
              (place-image (text "descending" 11 "green")
                           20 20
                           (render 10)))

(define (render/status y)
  (place-image
   (cond
     [(<= 0 y CLOSE) (text "descending" 11 "green")]
     [(and (< CLOSE y) (<= y HEIGHT)) (text "closing in" 11 "orange")]
     [(> HEIGHT) (text "landed" 11 "red")])
   20 20
   (render y)))