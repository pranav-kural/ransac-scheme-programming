#lang scheme

; Functions to work with files related to RANSAC
(provide readXYZ)

; function to read given point cloud file and return a list of 3d points
(define (readXYZ fileIn)
 (let ((sL (map (lambda s (string-split (car s)))
                (cdr (file->lines fileIn)))))
   (map (lambda (L)
          (map (lambda (s)
                 (if (eqv? (string->number s) #f)
                     s
                     (string->number s))) L)) sL)))

