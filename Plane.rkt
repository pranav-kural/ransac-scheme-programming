#lang scheme

; functions to work with a 3D Plane
(provide diff plane)

; function to get equation of a plane in 3D given list of 3 points
(define (plane p1 p2 p3)
  (let* (
           (v1 (diff p1 p3))
           (v2 (diff p1 p2))
           (a (- (* (second v1) (third v2)) (* (second v2) (third v1)))) ; a = [(v1.y * v2.z) - (v2.y * v1.z)]
           (b (- (* (first v2) (third v1)) (* (first v1) (third v2)))) ; b = [(v2.x * v1.z) - (v1.x * v2.z)]
           (c (- (* (first v1) (second v2)) (* (second v1) (first v2)))) ; c = [(v1.x * v2.y) - (v1.y * v2.x)]
           (d (* (- 0 1) (+ (+ (* a (first p1)) (* b (second p1))) (* c (third p1))))) ; d = [(a * p1.x) - (b * p1.y) + (c * p1.z)]
           )
     (list a b c d)
    ))
  


; function to get difference between two points
(define (diff p1 p2)
  ; (p2.x - p1.x, p2.y - p1.y, p2.z - p1.z)
  (list (- (first p2) (first p1)) (- (second p2) (second p1)) (- (third p2) (third p1))))