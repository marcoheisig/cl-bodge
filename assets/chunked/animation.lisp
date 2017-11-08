(in-package :cl-bodge.assets)


;;;
;;; Animation chunk
;;;

(define-chunk-structure (keyframe-sequence t)
  bone)


(define-chunk-structure (animation-chunk t keyframe-sequence))


(defmethod parse-chunk ((this (eql :animation)) params data)
  (make-animation-chunk data))