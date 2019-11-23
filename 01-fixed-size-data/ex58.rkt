;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex58) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Exercise 58. Introduce constant definitions that separate the intervals for low
; prices and luxury prices from the others so that the legislators in Tax Land can
; easily raise the taxes even more.

; The state of Tax Land has created a three-stage sales tax to cope with its budget
; deficit. Inexpensive items, those costing less than $1,000, are not taxed. Luxury
; items, with a price of more than $10,000, are taxed at the rate of eight percent (8.00%).
; Everything in between comes with a five percent (5.00%) markup.

; Design a function for a cash register that, given the price of an item, computes the sales tax.

; A Price falls into one of three intervals:
; - 0 through 1000
; - 1000 through 10000
; - 10000 and above
; interpretation the price of an item

(define INEXPENSIVE-ITEM-PRICE-THERSHOLD 0)
(define COMMON-ITEM-PRICE-THERSHOLD 1000)
(define LUXURY-ITEM-PRICE-THRESHOLD 10000)
(define INEXPENSIVE-ITEM-TAX-RATE 0.05)
(define COMMON-ITEM-TAX-RATE 0.05)
(define LUXURY-ITEM-TAX-RATE 0.08)

; Price -> Number
; computes the amount of tax charged for p
(check-expect (sales-tax 999) 0)
(check-expect (sales-tax 1000) 50)
(check-expect (sales-tax 2500) 125)
(check-expect (sales-tax 10000) 800)
(check-expect (sales-tax 15000) 1200)
(define (sales-tax p)
  (* p (cond
         [(and (<= INEXPENSIVE-ITEM-PRICE-THERSHOLD p)
               (< p COMMON-ITEM-PRICE-THRESHOLD)) INEXPENSIVE-ITEM-TAX-RATE]
         [(and (<= COMMON-ITEM-PRICE-THERSHOLD p)
               (< p LUXURY-ITEM-PRICE-THRESHOLD)) COMMON-ITEM-TAX-RATE]
         [(>= p LUXURY-ITEM-PRICE-THRESHOLD) LUXURY-ITEM-TAX-RATE])))