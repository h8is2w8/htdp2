;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex103) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 103. Develop a data representation for the following four kinds of zoo
; animals:
; - spiders, whose relevant attributes are the number of remaining legs (we
; assume that spiders can lose legs in accidents) and the space they need in case
; of transport;
; - elephants, whose only attributes are the space they need in case of transport;
; - boa constrictors, whose attributes include length and girth; and
; - armadillos, for which you must determine appropriate attributes, including one
; that determines the space needed for transport.
; 
; Develop a template for functions that consume zoo animals.
;
; Design the fits? function, which consumes a zoo animal and a description of a
; cage. It determines whether the cage’s volume is large enough for the animal.


(define-struct spider [legs space])
; Spider is a structure:
;   (make-spider NaturalNumber PositiveNumber)
; iterpretation: (make-spider l s) specifies a spider
; with number of legs l and required space s in case of transport
; ex: (make-spider 4 2)

(define-struct elephant [space])
; Elephant is a structure:
;   (make-elephant PositiveNumber)
; iterpretation: represents space an elephant require in case of transport.
; ex: (make-elephant 50)

(define-struct boa-contrictor [length girth])
; BoaConstrictor is a structure:
;   (make-boa-constrictor PositiveNumber PositiveNumber)
; interpretation: (make-boa-contrictor l g) specifies a boa constrictor
; with length l and grith g
; ex: (make-boa-constrictor 10 20)

(define-struct armadillo [color space])
; Armadillo is a structure:
;   (make-armadillo String PositiveNumber)
; interpretation: (make-armadillo c s) specifies an armadillo
; with color c and space s
; ex: (make-armadillo "black" 20)

; ZooAnimal is one of:
; - Spider
; - Elephant
; - BoaConstrictor
; - Armadillo
; interpretation: represents any animal in zoo

; Spider -> ...
(define (spider-template s)
  (... (spider-legs s)
       (spider-space s)))

; Elephant -> ...
(define (eleph-template e)
  (... (elephant-space e)))

; BoaConstrictor -> ...
(define (boa-constrictor-template bc)
  (... (boa-constrictor-length bc)
       (boa-constrictor-girth bc)))

; Armadilo -> ...
(define (armadilo-template a)
  (... (armadilo-color a)
       (armadilo-space a)))

; ZooAnimal -> ...
(define (zoo-template animal)
  (cond
    [(spider? animal) ...]
    [(elephant? animal) ...]
    [(boa-constrictor? animal) ...]
    [(armadilo? animal) ...]))

; ZooAnimal PositiveNumber -> Boolean
(define (fits? animal cage)
  (cond
    [(spider? animal)
     (> cage (spider-space animal))]
    [(elephant? animal)
     (> cage (elephant-space animal))]
    [(boa-constrictor? animal)
     (> cage
      (* (boa-constrictor-length bc)
         (boa-constrictor-girth bc)))]
    [(armadilo? animal)
     (> cage (armadillo-space animal))]))