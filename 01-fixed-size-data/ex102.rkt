;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex102) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
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
(define TANK-W (image-width TANK))

(define TANK-SPEED 2)
(define UFO-SPEED 1)
(define UFO-DELTA 9)
(define MISSILE-SPEED 4)



; Structures

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)

(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation: (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick


(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
;   (make-sigs UFO Tank MissileOrNot)
; interpretation: represents the complete state of a
; space invader game
 
; A MissileOrNot is one of: 
; – #false
; – Posn
; interpretation: #false means the missile is in the tank;
; Posn says the missile is at that location


; SIGS -> Image
; adds TANK, UFO, and possibly MISSLE to
; the BACKGROUND scene
(define (si-render s)
  (tank-render
   (sigs-tank s)
   (ufo-render (sigs-ufo s)
               (missile-render (sigs-missile s)
                               BACKGROUND))))

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
  (cond
    [(boolean? m) im]
    [(posn? m)
     (place-image MISSILE (posn-x m) (posn-y m) im)]))

; SIGS -> Bool
; checks if the UFO lands or if the missile hits the UFO
;
; MISSILE hasn't been sent yet and UFO landed
(check-expect (si-game-over? (make-sigs (make-posn 50 HEIGHT)
                                        (make-tank 60 4)
                                        #false))
              #true)
; MISSILE has been sent but UFO landed
(check-expect (si-game-over? (make-sigs (make-posn 60 HEIGHT)
                                         (make-tank 60 4)
                                         (make-posn 30 30)))
              #true)
; MISSILE hasn't been sent yet and UFO is still landing
(check-expect (si-game-over? (make-sigs (make-posn 50 10)
                                        (make-tank 60 4)
                                        #false))
              #false)
; MISSILE has been sent but hasn't hit UFO yet
(check-expect (si-game-over? (make-sigs (make-posn 60 20)
                                        (make-tank 60 4)
                                        (make-posn 30 30)))
              #false)
; MISSILE hit UFO
(check-expect (si-game-over? (make-sigs (make-posn 60 20)
                                        (make-tank 60 4)
                                        (make-posn 60 20)))
              #true)
(define (si-game-over? s)
  (or
   (ufo-landed? (sigs-ufo s))
   (ufo-hit? (sigs-missile s)
             (sigs-ufo s))))

; UFO -> Bool
; returns true if u reaches bottom of the scene
(check-expect (ufo-landed? (make-posn 50 HEIGHT)) #true)
(check-expect (ufo-landed? (make-posn 15 50)) #false)
(define (ufo-landed? u)
  (>= (posn-y u) HEIGHT))

; UFO MISSILE -> Bool
; check if m collides with u
; MISSILE is still in tank
(check-expect (ufo-hit? #false (make-posn 30 50)) #false)
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
  (cond
    [(boolean? m) #false]
    [(posn? m)
     (and
      (> (+ (posn-x m) (/ MISSILE-W 2)) (- (posn-x u) (/ UFO-W 2)))
      (< (- (posn-x m) (/ MISSILE-W 2)) (+ (posn-x u) (/ UFO-W 2)))
      (> (+ (posn-y m) (/ MISSILE-H 2)) (- (posn-y u) (/ UFO-H 2)))
      (< (- (posn-y m) (/ MISSILE-H 2)) (+ (posn-y u) (/ UFO-H 2))))]))

; SIGS -> Image
(define (si-render-final s)
  (overlay (text "GAME OVER" 24 "red")
           (si-render s)))

; SIGS -> SIGS
; This function is called for every clock tick to
; determine to which position the objects move now.
(define (si-move s)
  (si-move-proper s (random UFO-DELTA)))

; SIGS Number -> SIGS 
; moves the space-invader objects predictably by delta
(check-expect (si-move-proper
               (make-sigs (make-posn 50 50)
                          (make-tank 40 3)
                          #false)
               0)
              (make-sigs (make-posn 46 51)
                         (make-tank 43 3)
                         #false))
(check-expect (si-move-proper
               (make-sigs (make-posn 50 50)
                          (make-tank 30 -3)
                          (make-posn 30 30))
               2)
              (make-sigs (make-posn 48 51)
                         (make-tank 27 -3)
                         (make-posn 30 26)))
(define (si-move-proper s delta)
  (make-sigs (ufo-move (sigs-ufo s) delta)
             (tank-move (sigs-tank s))
             (missile-move (sigs-missile s))))

; UFO -> UFO
; descends UFO with small random jumps to the left or the right.
(check-expect (ufo-move (make-posn 38 41) 2)
              (make-posn 36 42))
(check-expect (ufo-move (make-posn 40 46) 0)
              (make-posn 36 47))
(check-expect (ufo-move (make-posn 40 46) 1)
              (make-posn 37 47))
(check-expect (ufo-move (make-posn (/ UFO-W 2) 50) 0)
              (make-posn (/ UFO-W 2) 51))
(check-expect (ufo-move (make-posn (- WIDTH (/ UFO-W 2)) 30) 2)
              (make-posn (- WIDTH (/ UFO-W 2) 2) 31))
(define (ufo-move u dt)
  (make-posn (ufo-get-x (ufo-next-x u dt) (posn-x u))
             (+ (posn-y u) UFO-SPEED)))

(define (ufo-next-x u dt)
  (+ (- (posn-x u) 4) dt))

(define (ufo-get-x new-x old-x)
  (if (and (> new-x (/ UFO-W 2))
           (< new-x (- WIDTH (/ UFO-W 2))))
      new-x
      old-x))

; TANK -> TANK
; update tank's position on x-axis by constant speed
(check-expect (tank-move (make-tank 20 3))
                         (make-tank 23 3))
(check-expect (tank-move (make-tank 40 -3))
                         (make-tank 37 -3))
(check-expect (tank-move (make-tank (/ TANK-W 2) -3))
                         (make-tank (/ TANK-W 2) -3))
(check-expect (tank-move (make-tank (/ TANK-W 2) 3))
                         (make-tank (+ (/ TANK-W 2) 3) 3))
(check-expect (tank-move (make-tank (- WIDTH (/ TANK-W 2)) 3))
                         (make-tank (- WIDTH (/ TANK-W 2)) 3))
(check-expect (tank-move (make-tank (- WIDTH (/ TANK-W 2)) -3))
                         (make-tank (- WIDTH (/ TANK-W 2) 3) -3))
(define (tank-move t)
  (if (or (<= (tank-next-loc t) (/ TANK-W 2))
          (>= (tank-next-loc t) (- WIDTH (/ TANK-W 2))))
      t (make-tank (tank-next-loc t)
                   (tank-vel t))))

(define (tank-next-loc t)
  (+ (tank-vel t) (tank-loc t)))


; MISSILE -> MISSILE
; updates missile's position on y-axis by constant speed
(check-expect (missile-move #false) #false)
(check-expect (missile-move (make-posn 50 50))
                            (make-posn 50 (- 50 MISSILE-SPEED)))
(define (missile-move m)
  (cond
    [(boolean? m) m]
    [(posn? m) 
     (make-posn (posn-x m)
                (- (posn-y m) MISSILE-SPEED))]))


; SIGS KeyEvent -> SIGS
; changes tank's direction or fires missile according to key press
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 3)
                                     #false)
                          "left")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 -3)
                        #false))
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 -3)
                                     #false)
                          "left")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 -3)
                         #false))
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 -3)
                                     #false)
                          "right")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 3)
                         #false))
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 3)
                                     #false)
                          "right")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 3)
                         #false))
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 3)
                                     #false)
                          " ")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 3)
                         (make-posn 40 240)))
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 3)
                                     (make-posn 40 20))
                          " ")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 3)
                         (make-posn 40 20)))
(check-expect (si-control (make-sigs (make-posn 50 50)
                                     (make-tank 40 3)
                                     #false)
                          "b")
              (make-sigs (make-posn 50 50)
                         (make-tank 40 3)
                         #false))
(define (si-control s ke)
  (cond
    [(or (string=? ke "left")
         (string=? ke "right"))
     (make-sigs (sigs-ufo s)
                (tank-turn (sigs-tank s) ke)
                (sigs-missile s))]
    [(and (boolean? (sigs-missile s))
          (string=? ke " "))
     (si-fire s)]
    [else s]))

; Tank String -> Tank
(define (tank-turn t dir )
  (make-tank
   (tank-loc t)
   (cond
     [(string=? dir "left") (tank-turn-left t)]
     [(string=? dir "right") (tank-turn-right t)])))

; Tank -> Number
(define (tank-turn-left t)
  (if (> (tank-vel t) 0)
      (* -1 (tank-vel t))
      (tank-vel t)))

; Tank -> Number
(define (tank-turn-right t)
  (if (< (tank-vel t) 0)
      (* -1 (tank-vel t))
      (tank-vel t)))


; SIGS -> SIGS
(check-expect (si-fire (make-sigs (make-posn 50 50)
                                  (make-tank 40 3)
                                  #false))
              (make-sigs (make-posn 50 50)
                         (make-tank 40 3)
                         (make-posn 40 (+ HEIGHT 40))))
(define (si-fire s)
  (make-sigs
   (sigs-ufo s)
   (sigs-tank s)
   (make-posn (tank-loc (sigs-tank s))
              (+ HEIGHT 40))))



; SIGS -> SIGS
(define (si-main s)
  (big-bang s
    [to-draw si-render]
    [on-tick si-move]
    [stop-when si-game-over? si-render-final]
    [on-key si-control]))

(define (test k)
  (si-main (make-sigs (make-posn 50 50)
                      (make-tank 40 3)
                      #false)))