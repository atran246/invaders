;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |space invaders|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; Andrew Tran Space Invaders
(require 2htdp/image)
(require 2htdp/universe)

; physical constants 
(define HEIGHT 80)
(define WIDTH 100)
(define XSHOTS (/ WIDTH 2))

; graphical constants 

(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SHOT (triangle 3 "solid" "red"))


; A List-of-shots is one of: 
; – empty
; – (cons Shot List-of-shots)
; interp.: the collection of shots fired and moving straight up

; A Shot is a Number. 
; interp.: the number represents the shot's y coordinate


; A ShotWorld is List-of-numbers. 
; interp.: the collection of shots fired and moving straight up
; ShotWorld -> ShotWorld 
; move each shot up by one pixel 
(check-expect (tock (list 9 8 7)) (list 8 7 6)) 
(check-expect (tock (list 100 46 12 9)) (list 99 45 11 8))
(check-expect (tock empty) empty)
(define (tock w)
  (cond
    [(empty? w) empty]
    [(above? (first w )) (tock (rest w))]
    [else (cons (sub1 (first w)) (tock (rest w)))]))

; Number -> Number
; to determine whether a shot is above the canvas or not
(check-expect (above? 2) false)
(check-expect (above? -2) true)
(define (above? n)
  (cond
    [(< n 0) true]
    [else false]))
   
    

; ShotWorld KeyEvent -> ShotWorld 
; add a shot to the world if the space bar was hit 
(check-expect (keyh (list 234 33) " ") (list 80 234 33))
(check-expect (keyh (list 234 33) "A") (list 234 33))
(define (keyh w ke)
  (cond
    [(key=? ke " ") (cons HEIGHT w)]
    [else w]))

; ShotWorld -> Image 
; add each shot y on w at (MID,y) to the background image 
(check-expect (to-image (list 234 33))
                        (place-image SHOT XSHOTS 234 
                                     (place-image SHOT XSHOTS 33 BACKGROUND)))
(check-expect (to-image empty) BACKGROUND)
(define (to-image w)
  (cond
    [(empty? w) BACKGROUND]
    [else (place-image SHOT XSHOTS (first w) (to-image (rest w)))]))

; ShotWorld -> ShotWorld 
(define (main w0)
  (big-bang w0  
            (on-tick tock)
            (on-key keyh)
            (to-draw to-image)))


; Main takes a list of Y values for shots then creates a world in which 
; every tick the y values are increased by 1, adds another shot into the world
; when a key is pressed, and draws the world on the screen.


