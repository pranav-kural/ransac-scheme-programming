#lang scheme

; import required files
(require "RANSACFiles.rkt") ; function to read and write to file
(require "utilities.rkt") ; generic utilities

(println "RANSAC Started")

; set debug mode
(set-debug #t)

; sample filename with path
(define TEST_FILE "./data/input/Point_Cloud_1_No_Road_Reduced.xyz")

; read file and load the list of 3D points
(define Ps (readXYZ TEST_FILE))


; function to pick 3 random points from list of points
(println (list-ref Ps (random (length Ps))))