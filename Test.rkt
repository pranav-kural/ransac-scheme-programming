#lang scheme


(require "Plane.rkt")
(require "RANSACFiles.rkt") ; function to read and write to file
(require "utilities.rkt") ; generic utilities

(println "Running Test")

; set debug mode
(set-debug #t)

; sample filename with path
(define TEST_FILE "./data/input/Point_Cloud_1_No_Road_Reduced.xyz")

; read file and load the list of 3D points
(define Ps (readXYZ TEST_FILE))

; function to pick 3 random points from list of points
(define Point1 (list-ref Ps (random (length Ps))))
(define Point2 (list-ref Ps (random (length Ps))))
(define Point3 (list-ref Ps (random (length Ps))))

; function to generate plane equation
(printlistn "Selected random points: " (list Point1 Point2 Point3))
;(println Point1)

; Testing diff
(define (test-diff)
  (let* ((tp1 '(32 10 5)) (tp2 '(12 5 3)) (expected '(20 5 2)) (actual (diff tp2 tp1)))
  (println "-------- Testing Point Difference --------")
  (newline)
  (println "Test lists: (32 10 5), (12 5 3), Expected difference: (20 5 2)")
  (printlist (list "Actual difference: " actual))
  (println (if (equal? actual expected)
               "#: Test Passed"
               "#: Test Failed"))
       ))
(test-diff)

;Testing Plane equation calculation
(define (test-plane)
  (newline)
  (println "-------- Tesing Plane Equation -------- ")
  (newline)
  (println "Excepted Result: a: -19.24478941973517, b: -22.416438566567404, c: 84.2872272864299, d: 74.52946568859088") ; computed using different program
  (let*
      ((p1 '(11.41738472 -2.858225095 0.962476455))
       (p2 '(3.408226942 -0.062265186 -0.12261193))
       (p3 '(11.64480557 7.586239857 3.792138564))
       (expected '(-19.24478941973517 -22.416438566567404 84.2872272864299 74.52946568859088))
       (actual (plane p1 p2 p3)))
    (printlistn "Actual Result: (each line in order a, b, c, d)" actual)
    (println (if (equal? actual expected)
               "#: Test Passed"
               "#: Test Failed"))
       )
    )
(test-plane)
