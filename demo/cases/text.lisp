(cl:defpackage :cl-bodge.text.demo
  (:use :cl :cl-bodge.demo.api))
(cl:in-package :cl-bodge.text.demo)


(defclass text-showcase ()
  ())

(register-showcase 'text-showcase)


(defmethod showcase-name ((this text-showcase))
  "SDF Text")


(defmethod showcase-revealing-flow ((this text-showcase) ui)
  (with-slots () this
    (ge:>>
     (ge:instantly ()))))


(defmethod showcase-closing-flow ((this text-showcase))
  (with-slots (universe ground ball box) this
    (ge:instantly ())))


(defmethod render-showcase ((this text-showcase))
  (with-slots () this))
