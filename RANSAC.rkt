#lang scheme

; import required files
(require "RANSACFiles.rkt") ; function to read and write to file
(require "Plane.rkt") ; function to work with 3D plane
(require "utilities.rkt") ; generic utilities

(provide ransacNumberOfIterations planeRANSAC)

; used in debugging to print additional informative messages (printd, printdl)
(set-debug #f)

; sample filename with path
(define TEST_FILE "./data/input/Point_Cloud_1_No_Road_Reduced.xyz")

; function to get a list of three randomly selected points from point cloud
(define (getThreeRandomPoints points)
  (let ((pl (length points)))
  (list (list-ref points (random pl)) (list-ref points (random pl)) (list-ref points (random pl)))))

; function to calculate the number of iterations required for RANSAC
(define (ransacNumberOfIterations confidence percentage)
  (inexact->exact (floor (/ (log (- 1 confidence)) (log (- 1 (* percentage percentage percentage)))))))

; RANSAC algorithm
; Pseudo-code
; Initialize a bestPlane variable to hold the pair (<plane> <support>)
; Loop: for the numberOfIterations
;  - Extract a random plane by choosing three points at random from point cloud
;  - Get support of the plane in the point cloud
;  - If: support of current plane greater than support of current best plane, update best plane
; Return: best plane
(define (ransac points eps numOfIterations)
  (define bestSupport (cons '() 0))
  (printlist (list "---- Staring RANSAC ----" "Size of point cloud: " (length points) ", eps: " eps ", number of iterations: " numOfIterations))
  (and (do ((i 0 (+ i 1)))
         ((> i numOfIterations))
         (let* (
                (randomPoints (getThreeRandomPoints points))
                (plane (getPlane (first randomPoints) (second randomPoints) (third randomPoints)))
                (support (getPlaneSupport plane points eps)))
           (if (> (cdr support) (cdr bestSupport))
               (and (set! bestSupport support) (printdl (list "Better dominant plane found " bestSupport)))
               #t)))
       bestSupport)
  )

; function to validate inputs and initiate ransac
(define (planeRANSAC filename confidence percentage eps)
  (if (empty? filename)
      (printerr "Invalid filename, no filename provided")
      (if (or (< confidence 0) (< percentage 0) (< eps 0))
          (and (printerrl "Invalid parameter values for RANSAC. Negative values provided" (list "confidence: " confidence "percentage: " percentage "eps: " eps)) '())
          (ransac (readXYZ filename) eps (ransacNumberOfIterations confidence percentage))))) ; if all inputs valid, run ransac and return dominant plane
           
