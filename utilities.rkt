#lang scheme

; Utility functions
(provide
 set-debug ; set DEBUG mode
 println   ; print line
 printlist ; print list, first element heading
 printd    ; print only when DEBUG is ON
 printdl   ; print list only when DEBUG is ON
 )

; DEBUG Mode
(define DEBUG #f)

; function to update debug mode
(define (set-debug debugMode)
  (set! DEBUG debugMode)
  (printlist (list "DEBUG mode : " DEBUG)))

; function to print message and then a newline
(define println
  (lambda (x)
    (display x)
    (newline)))

; function to display elements of given list where first element is title and tail contains list to be printed
(define (printlist lst)
  (display (car lst))
  (for-each display (cdr lst))
  (newline))
    
; print when DEBUG is ON
(define (printd x)
  (if (equal? DEBUG #t)
      (println x)
      (display "")))
    

; if debug mode is ON, given list of elements, print each element on a new line
(define (printdl x)
  (if (eqv? DEBUG #t)
      (if (null? (cdr x)) ; if at end of list
          (println (car x)) ; print last element
          (and
           (println (car x))
           (printdl (cdr x)))) ; recursively call for printing next element
       (display "")))