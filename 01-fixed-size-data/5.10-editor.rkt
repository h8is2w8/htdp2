;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname editor) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/image)
(require 2htdp/universe) 

(define CURSOR (rectangle 1 20 "solid" "red"))
(define MT (empty-scene 200 20))
(define FONT_SIZE 16)

(define-struct editor (prev next))
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with
; the cursor displayed between s and t


; String -> Image
; renders editor text
(check-expect (render-text "hell")
              (text "hell" FONT_SIZE "black"))
(define (render-text txt)
  (text txt FONT_SIZE "black"))
  

; Editor -> Image
; renders the editor and places cursor between prev and next text
(check-expect (render (make-editor "hello" "world"))
                      (overlay/align "left" "center"
                                     (beside (render-text "hello") CURSOR (render-text "world"))
                                     (empty-scene 200 20)))
(define (render ed)
  (overlay/align "left" "center"
               (beside (render-text (editor-prev ed))
                       CURSOR
                       (render-text (editor-next ed)))
               MT))

; String -> 1String
; retrieves the first character of given String s
(define (string-first s)
  (substring s 0 1))

; String -> 1String
; retrieves the last character of given String s
(define (string-last s)
  (substring s (- (string-length s) 1) (string-length s)))

; String -> String
(define (string-rest s)
  (substring s 1 (string-length s)))

; String -> String
(define (string-remove-last s)
  (substring s 0 (- (string-length s) 1)))

; Editor, KeyEvent -> Editor
; updates Editor text after keystroke
(check-expect (edit (make-editor "" "") "o")
              (make-editor "o" ""))
(check-expect (edit (make-editor "helloworld" "") "!")
              (make-editor "helloworld!" ""))
(check-expect (edit (make-editor "hello" "world") " ")
              (make-editor "hello " "world"))
(check-expect (edit (make-editor "hello" "world") "left")
              (make-editor "hell" "oworld"))
(check-expect (edit (make-editor "helloworld" "") "left")
              (make-editor "helloworl" "d"))
(check-expect (edit (make-editor "" "helloworld") "left")
              (make-editor "" "helloworld"))
(define (edit ed ke)
  (cond
    [(string=? "left" ke) (move-cursor-left ed)]
    [(string=? "right" ke) (move-cursor-right ed)]
    [(string=? "\b" ke) (delete-last-char ed)]
    [(and (= (string-length ke) 1)
          (not (key=? ke "\t"))
          (not (key=? ke "\r")))
     (make-editor (string-append (editor-prev ed) ke)
                  (editor-next ed))]
    [else ed]))

; Editor -> Editor
; changes editor cursor pos by one char to the left
(check-expect (move-cursor-left (make-editor "" "abc"))
              (make-editor "" "abc"))
(check-expect (move-cursor-left (make-editor "abc" ""))
              (make-editor "ab" "c"))
(check-expect (move-cursor-left (make-editor "ab" "cd"))
              (make-editor "a" "bcd"))
(define (move-cursor-left ed)
  (if (> (string-length (editor-prev ed)) 0)
      (make-editor (string-remove-last (editor-prev ed))
                   (string-append (string-last (editor-prev ed)) (editor-next ed)))
      ed))

; Editor -> Editor
; change editor cursor pos by one char to the right
(check-expect (move-cursor-right (make-editor "" "abc"))
              (make-editor "a" "bc"))
(check-expect (move-cursor-right (make-editor "ab" "cd"))
              (make-editor "abc" "d"))
(check-expect (move-cursor-right (make-editor "abc" "d"))
              (make-editor "abcd" ""))
(define (move-cursor-right ed)
  (if (> (string-length (editor-next ed)) 0)
      (make-editor (string-append (editor-prev ed) (string-first (editor-next ed)))
                   (string-rest (editor-next ed)))         
      ed))

; Editor -> Editor
; removes character before cursor
(check-expect (delete-last-char (make-editor "" "abc"))
              (make-editor "" "abc"))
(check-expect (delete-last-char (make-editor "ab" "cd"))
              (make-editor "a" "cd"))
(check-expect (delete-last-char (make-editor "abcd" ""))
              (make-editor "abc" ""))
(define (delete-last-char ed)
  (if (> (string-length (editor-prev ed)) 0)
      (make-editor (string-remove-last (editor-prev ed)) (editor-next ed))
      ed))

; String -> Editor
(define (run pre)
  (big-bang (make-editor pre "")
    [to-draw render]
    [on-key edit]))