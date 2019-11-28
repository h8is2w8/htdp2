;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname editor2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define CURSOR (rectangle 1 20 "solid" "red"))
(define BG (empty-scene 200 20))

(define-struct editor [text pos])
; An Editor is a struct:
;  (make-editor String Number)
; interpretation (make-editor t p) describes editor
; with text and the cursor displayed at pos

; Editor, KeyEvent -> Editor
; updates editor after keystroke
(check-expect (edit (make-editor "zero" 0) "\n")
              (make-editor "zero" 0))
(check-expect (edit (make-editor "zero" 0) "\t")
              (make-editor "zero" 0))
(check-expect (edit (make-editor "hello" 3) "\b")
              (make-editor "helo" 2))
(check-expect (edit (make-editor "hello" 0) "\b")
              (make-editor "hello" 0))
(check-expect (edit (make-editor "hello" 5) "\b")
              (make-editor "hell" 4))
(check-expect (edit (make-editor "hello" 0) "right")
              (make-editor "hello" 1))
(check-expect (edit (make-editor "hello" 5) "right")
              (make-editor "hello" 5))
(check-expect (edit (make-editor "hello" 5) "left")
              (make-editor "hello" 4))
(check-expect (edit (make-editor "hello" 0) "left")
              (make-editor "hello" 0))
(check-expect (edit (make-editor "hello" 3) " ")
              (make-editor "hel lo" 4))
(check-expect (edit (make-editor "hello" 0) "!")
              (make-editor "!hello" 1))
(define (edit ed ke)
  (cond
    [(string=? ke "\b") (remove-char ed)]
    [(string=? ke "right") (move-right ed)]
    [(string=? ke "left") (move-left ed)]
    [(and (= (string-length ke) 1)
          (not (string=? ke "\n"))
          (not (string=? ke "\t")))
          (write-char ed ke)]
    [else ed]))

; Editor -> Editor
; remove character before cursor
(define (remove-char ed)
  (if (> (editor-pos ed) 0)
      (make-editor (string-append (substring (editor-text ed) 0 (- (editor-pos ed) 1))
                                  (substring (editor-text ed) (editor-pos ed) (string-length (editor-text ed))))
                   (- (editor-pos ed) 1))
      ed))
                                         

; Editor -> Editor
; moves Editor cursor to the right
(define (move-right ed)
  (if (< (editor-pos ed) (string-length (editor-text ed)))
      (make-editor (editor-text ed) (+ (editor-pos ed) 1))
      ed))

; Editor -> Editor
; moves Editor cursor to the left
(define (move-left ed)
  (if (> (editor-pos ed) 0)
      (make-editor (editor-text ed) (- (editor-pos ed) 1))
      ed))

; Editor -> Editor
; add character to the Editor text
(define (write-char ed char)
  (make-editor (string-append (substring (editor-text ed) 0 (editor-pos ed)) char
                              (substring (editor-text ed) (editor-pos ed) (string-length (editor-text ed))))
               (+ (editor-pos ed) 1)))


; String -> Image
(define (render-text txt)
  (text txt 16 "black"))

; Editor -> Image
; renders Editor
(define (render ed)
  (overlay/align "left" "center"
                 (beside (render-text (substring (editor-text ed) 0 (editor-pos ed)))
                         CURSOR
                         (render-text (substring (editor-text ed) (editor-pos ed)
                                                 (string-length (editor-text ed)))))
                 (empty-scene 200 20)))

; String -> Editor
(define (run text)
  (big-bang (make-editor text (string-length text))
      [to-draw render]
      [on-key edit]))