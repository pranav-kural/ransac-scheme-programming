#lang scheme

; import dependencies
(require "Plane.rkt") ; function to work with 3D plane
(require "RANSAC.rkt") ; RANSAC algorithmic functions
(require "utilities.rkt") ; generic utilities

; Test functions to test important core methods
; Most of the expected values against which actual function outputs are compared with, have been generated from
; a verified Java based RANSAC implementation which is known to produce correct values

; store test point cloud filename and path globally - used in some tests (like test-read, test-support, etc.)
(define TEST_FILE "./data/input/Point_Cloud_1_No_Road_Reduced.xyz")

(define (test-read)
  (println "-------- Testing Reading Point Cloud -------- ")
  (println "Reading Sample Point Cloud file and displaying randomly selected 3 points")
 
  ; read file and load the list of 3D points
  (define Ps (readXYZ TEST_FILE))

  ; function to pick 3 random points from list of points
  (define Point1 (list-ref Ps (random (length Ps))))
  (define Point2 (list-ref Ps (random (length Ps))))
  (define Point3 (list-ref Ps (random (length Ps))))

  ; function to generate plane equation
  (printlistn "Selected random points: " (list Point1 Point2 Point3))
  (println "#: Test Passed ")
  (newline))
  

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
    (newline)
       ))


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
       (actual (getPlane p1 p2 p3)))
    (printlistn "Actual Result: (each line in order a, b, c, d)" actual)
    (println (if (equal? actual expected)
               "#: Test Passed"
               "#: Test Failed"))
    (newline)
       )
    )


; Test: Getting distance of point to plane
(define (test-distance)
  (let* (
         (p1 '(12.1422584 15.95857346 5.677742716))
         (plane '(-19.24478941973517 -22.416438566567404 84.2872272864299 74.52946568859088))
         (expected 0.4290306042682359)
         (actual (getDistanceFromPlane p1 plane)))
  (println "-------- Testing Distance from Plane --------")
  (newline)
  (printlistn "Test parameters" (list (list "Test point: " p1) (list "plane: " plane) (list " Expected distance: " expected)))
  (printlist (list "Actual distance: " actual))
  (println (if (equal? actual expected)
               "#: Test Passed"
               "#: Test Failed"))
    (newline)
       ))

; Test: supporting points for plane
(define (test-support)
  (let* (
         (points (readXYZ TEST_FILE))
         (plane '(-19.24478941973517 -22.416438566567404 84.2872272864299 74.52946568859088))
         (eps 0.5)
         (expected 1532)
         (actual (cdr (getPlaneSupport plane points eps))))
    (println "-------- Testing Plane Support --------")
    (newline)
    (printlistn "Test parameters" (list (list "Test plane: " plane) (list "eps: " eps) (list "Size of point cloud: " (length points)) (list "Expected support: " expected)))
    (printlist (list "Actual support: " actual))
    (println (if (equal? actual expected)
                 "#: Test Passed"
                 "#: Test Failed"))
    (newline)
    ))

; Test number of iterations
(define (test-num-iterations)
  (let* (
        (confidence 0.99)
        (percentage 0.3)
        (expected 168)
        (actual (ransacNumberOfIterations confidence percentage)))
        (println "-------- Testing Number of Iterations --------")
    (newline)
    (printlistn "Test parameters" (list (list "confidence: " confidence) (list "percentage: " percentage) (list "Expected number of iterations: " expected)))
    (printlist (list "Actual number of iterations: " actual))
    (println (if (equal? actual expected)
                 "#: Test Passed"
                 "#: Test Failed"))
    (newline)
    ))

; Test: RANSAC algorithm
(define (test-ransac)
  (println "-------- Testing RANSAC --------")
  (newline)
  (let* (
         (confidence 0.99)
         (percentage 0.3)
         (eps 0.5)
         (expected 1800) ; appromixate minimum amount of supporting points when percentage is around 30%, confidence is 99% and epsilion 0.5
         (actual (planeRANSAC TEST_FILE confidence percentage eps)))
    (printlistn "Test parameters" (list (list "confidence: " confidence) (list "percentage: " percentage) (list "eps: " eps) (list "Expected minimum dominant plane size: " expected)))
    (display "Actual size of dominant plane: ")
    (display (cdr actual))
    (newline)
    (printlist (list "" "Dominant plane ((a b c d) . <supporting points>): " actual))
    (println (if (> (cdr actual) expected)
                 "#: Test Passed"
                 "#: Test Failed"))
    (newline)
    ))

; Main test function
(define (run-tests)
  (println "-------- Running Tests --------")
  (newline)
  ; Can comment out functions which you don't want to run the test for
  (test-read)
  (test-diff)
  (test-plane)
  (test-distance)
  (test-support)
  (test-num-iterations)
  (test-ransac)
  )
; initiate the tests
(run-tests)
