#lang scheme

; import required files
(require "Plane.rkt") ; function to work with 3D plane
(require "utilities.rkt") ; generic utilities

; export functions
(provide readXYZ ransacNumberOfIterations planeRANSAC)

; function to read given point cloud file and return a list of 3d points
(define (readXYZ fileIn)
 (let ((sL (map (lambda s (string-split (car s)))
                (cdr (file->lines fileIn)))))
   (map (lambda (L)
          (map (lambda (s)
                 (if (eqv? (string->number s) #f)
                     s
                     (string->number s))) L)) sL)))

; function to get a list of three randomly selected points from point cloud
(define (getThreeRandomPoints points)
  (let ((pl (length points)))
  (list (list-ref points (random pl)) (list-ref points (random pl)) (list-ref points (random pl)))))

; function to calculate the number of iterations required for RANSAC
(define (ransacNumberOfIterations confidence percentage)
  (inexact->exact (floor (/ (log (- 1 confidence)) (log (- 1 (* percentage percentage percentage)))))))


; helper function for ransac - implements the RANSAC algorithm
(define (ransacAux points eps numOfIterations bestSupport)
  ; base case
  (if (<= numOfIterations 0)
      bestSupport ; return result
      ; recurvise case
      (let* (    
                (randomPoints (getThreeRandomPoints points)) ; get three random points
                (plane (getPlane (first randomPoints) (second randomPoints) (third randomPoints))) ; get equation of the plane formed from three points
                (support (getPlaneSupport plane points eps))) ; get support of the plane
           ; if found a plane with better support than current best support plane
           (if (> (cdr support) (cdr bestSupport))
               ; decrement number of iterations in each recursive call
               (ransacAux points eps (- numOfIterations 1) support) ; recursive call with new support plane
               (ransacAux points eps (- numOfIterations 1) bestSupport) ; recursive call with old best support plane
               ))))

; function to validate inputs and initiate ransac
(define (planeRANSAC filename confidence percentage eps)
  (if (empty? filename)
      (printerr "Invalid filename, no filename provided")
      (if (or (< confidence 0) (< percentage 0) (< eps 0))
          (and (printerrl "Invalid parameter values for RANSAC. Negative values provided" (list "confidence: " confidence "percentage: " percentage "eps: " eps)) '())
          (; if all inputs valid, run ransac and return dominant plane
           let (
                (points (readXYZ filename)) ; get list of points
                (numOfIterations (ransacNumberOfIterations confidence percentage))) ; calc num of iterations
           (printlist (list "---- Staring RANSAC ----" "Size of point cloud: " (length points) ", eps: " eps ", number of iterations: " numOfIterations))
           ; make call to the auxiliary recursive function with bestSupport argument initially empty pair
           (ransacAux points eps numOfIterations (cons '() 0)))

          ))) 