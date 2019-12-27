;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex109) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 109. Design a world program that recognizes a pattern in a sequence
; of KeyEvents. Initially the program shows a 100 by 100 white rectangle. Once
; your program has encountered the first desired letter, it displays a yellow
; rectangle of the same size. After encountering the final letter, the color of
; the rectangle turns green. If any “bad” key event occurs, the program displays
; a red rectangle.

(require 2htdp/universe)

(define WIDTH 100)
(define HEIGHT 100)

; ExpectsToSee is one of:
; – AA
; – BB
; – DD 
; – ER 
 
(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")

; ExpectsToSee KeyEvent -> ExpectsToSee
; moves to the next state
(check-expect (press AA "a") BB)
(check-expect (press AA "z") ER)
(check-expect (press BB "b") BB)
(check-expect (press BB "c") BB)
(check-expect (press BB "d") DD)
(check-expect (press BB "x") ER)
(check-expect (press ER "n") ER)
(check-expect (press DD "m") DD)
(define (press s ke)
  (cond
    [(string=? s AA)
     (if (key=? "a" ke) BB ER)]
    [(string=? s BB)
     (cond
       [(or (key=? ke "b") (key=? ke "c")) BB]
       [(key=? ke "d") DD]
       [else ER])]
     [else s]))

; ExpectsToSee -> Image
(define (render s)
  (rectangle
   WIDTH HEIGHT
   "solid"
   (cond
     [(string=? s AA) "white"]
     [(string=? s BB) "yellow"]
     [(string=? s DD) "green"]
     [(string=? s ER) "red"])))

; ExpectsToSee -> ExpectsToSee
(define (main s)
  (big-bang s
    [to-draw render]
    [on-key press]))