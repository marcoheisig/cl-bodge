(cl:in-package :cl-bodge.physics.chipmunk)


(defvar +cpv-zero+ (claw:calloc '%cp:vect))


(definline cp-float (val)
  (float val 0d0))


(definline init-cp-vect (vect bodge-vec)
  (claw:c-val ((vect %cp:vect))
    (setf (vect :x) (cp-float (x bodge-vec))
          (vect :y) (cp-float (y bodge-vec)))
    vect))


(definline set-cp-vect (vect x y)
  (claw:c-val ((vect %cp:vect))
    (setf (vect :x) (cp-float x)
          (vect :y) (cp-float y))
    vect))


(definline init-bodge-vec (bodge-vec cp-vect)
  (claw:c-val ((cp-vect %cp:vect))
    (setf (x bodge-vec) (cp-vect :x)
          (y bodge-vec) (cp-vect :y))
    bodge-vec))


(defmacro with-cp-vect ((vect &optional bodge-vec) &body body)
  `(claw:c-with ((,vect %cp:vect))
     ,@(when bodge-vec
         `((init-cp-vect ,vect ,bodge-vec)))
     ,@body))
