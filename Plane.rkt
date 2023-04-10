#lang scheme

; functions to work with a 3D Plane
(provide diff getPlane getDistanceFromPlane getPlaneSupport)

; function to get equation of a plane in 3D given list of 3 points
(define (getPlane p1 p2 p3)
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

; function to calculate distance from point to plane
(define (getDistanceFromPlane p1 plane)
  (let (
        (a (first plane))
        (b (second plane))
        (c (third plane))
        (d (fourth plane)))
  (/ (abs (+ (* a (first p1)) (* b (second p1)) (* c (third p1)) d)) (sqrt(+ (* a a) (* b b) (* c c))))))

; function to calculate the support of a plane
; Pseudo-code
; Given a 3D plane equation and a list of all 3D points of a point cloud
;  - initialize variable to hold support of the plane with initial value zero
;  - Loop: through each 3D Point
;    - If: distance of point to given plane <= eps
;      - increment the support of plane
;  - Return: a pair containing plane and number of supporting points
(define (getPlaneSupport plane points eps)
  (define support 0) ; initial value
  (for-each
   (lambda (point)
     (if (<= (getDistanceFromPlane point plane) eps)
         (set! support (+ 1 support))
         #t)) points)
  (cons plane support))