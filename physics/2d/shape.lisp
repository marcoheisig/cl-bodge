(cl:in-package :cl-bodge.physics.chipmunk)


;;;
;;; SHAPE
;;;
(defhandle shape-handle
  :closeform (%cp:shape-free *handle-value*))


(defclass chipmunk-shape (disposable)
  ((handle :initarg :handle :initform (error ":handle missing") :reader handle-of)
   (universe :initform nil :initarg :universe)
   (body :initform nil :initarg body)
   (substance :initarg :substance :initform nil)))


(define-destructor chipmunk-shape (universe (shape-handle handle-of))
  (%remove-and-free-shape universe shape-handle))


(defmethod initialize-instance :after ((this chipmunk-shape) &key universe)
  (register-shape universe (cffi:pointer-address (claw:ptr (handle-value-of this))) this))


(defmethod simulation-engine-destroy-shape ((this chipmunk-engine) (shape chipmunk-shape))
  (dispose shape))


(defmethod simulation-engine-shape-substance ((this chipmunk-engine) (shape chipmunk-shape))
  (with-slots (substance) shape
    substance))


(defmethod simulation-engine-shape-body ((this chipmunk-engine) (shape chipmunk-shape))
  (with-slots (body) shape
    body))


(defun body-handle-or-static (universe body)
  (if (null body)
      (universe-static-body universe)
      (handle-value-of body)))


;;;
;;; SEGMENT
;;;
(defclass segment-shape (chipmunk-shape) ())


(defmethod initialize-instance ((this segment-shape) &rest args
                                &key start end body universe)
  (claw:c-with ((a %cp:vect)
                (b %cp:vect))
    (init-cp-vect a start)
    (init-cp-vect b end)
    (apply #'call-next-method this
           :handle (make-shape-handle
                    (%cp:segment-shape-new (body-handle-or-static universe body) a b (cp-float 0.0)))
           args)))


(defmethod simulation-engine-make-segment-shape ((engine chipmunk-engine) (universe universe)
                                                 (start vec2) (end vec2) &key body substance)
  (let ((shape (make-instance 'segment-shape
                              :universe universe
                              :start start
                              :end end
                              :substance substance
                              :body body)))
    (%cp:space-add-shape (handle-value-of universe) (handle-value-of shape))
    shape))


;;;
;;; POLYLINE
;;;
(defclass polyline-shape (disposable)
  ((segments :initarg :segments)))


(define-destructor polyline-shape (segments)
  (loop for segment in segments
        do (dispose segment)))


(defun make-poly-segment (engine universe body substance prev origin end next)
  (with-cp-vect (cp-vect-prev)
    (with-cp-vect (cp-vect-next)
      (let ((shape (simulation-engine-make-segment-shape engine universe origin end
                                                         :body body
                                                         :substance substance)))
        (%cp:segment-shape-set-neighbors (handle-value-of shape)
                                         (init-cp-vect cp-vect-prev (or prev origin))
                                         (init-cp-vect cp-vect-next (or next end)))
        shape))))


(defmethod simulation-engine-make-polyline-shape ((engine chipmunk-engine) (universe universe)
                                                  points &key body substance)
  (let ((segments (loop for (prev origin end next) on (nconc (list nil) points)
                        while (and origin end)
                        collect (make-poly-segment engine universe body substance
                                                   prev origin end next))))
    (make-instance 'polyline-shape :segments segments)))


(defmethod simulation-engine-destroy-shape ((this chipmunk-engine) (shape polyline-shape))
  (with-slots (segments) shape
    (loop for segment in segments
          do (simulation-engine-destroy-shape this segment))))


(defmethod simulation-engine-shape-substance ((this chipmunk-engine) (shape polyline-shape))
  (with-slots (segments) shape
    (when segments
      (simulation-engine-shape-substance this (first segments)))))


(defmethod simulation-engine-shape-body ((this chipmunk-engine) (shape polyline-shape))
  (with-slots (segments) shape
    (when segments
      (simulation-engine-shape-body this (first segments)))))


;;;
;;; CIRCLE
;;;
(defclass circular-shape (chipmunk-shape) ())


(defmethod initialize-instance ((this circular-shape) &rest args &key radius body universe)
  (with-cp-vect (zero-vect)
    (setf (zero-vect :x) (cp-float 0)
          (zero-vect :y) (cp-float 0))
    (apply #'call-next-method this
           :handle (make-shape-handle (%cp:circle-shape-new (body-handle-or-static universe body)
                                                            (cp-float radius) zero-vect))
           args)))


(defmethod simulation-engine-make-circle-shape ((engine chipmunk-engine) (universe universe)
                                                (radius number) &key body substance)
  (let ((shape (make-instance 'circular-shape
                              :universe universe
                              :radius radius
                              :substance substance
                              :body body)))
    (%cp:space-add-shape (handle-value-of universe) (handle-value-of shape))
    shape))


;;;
;;; POLYGON
;;;
(defclass polygon-shape (chipmunk-shape) ())


(defmethod initialize-instance ((this polygon-shape) &rest args
                                &key points body universe)
  (let ((point-count (length points)))
    (claw:c-with ((f-points %cp:vect :count point-count)
                  (f-transform %cp:transform))
      (setf (f-transform :a) (cp-float 1)
            (f-transform :b) (cp-float 0)
            (f-transform :c) (cp-float 0)
            (f-transform :d) (cp-float 1)
            (f-transform :tx) (cp-float 0)
            (f-transform :ty) (cp-float 0))
      (loop for point in points
            for i from 0
            do (setf (f-points i :x) (cp-float (x point))
                     (f-points i :y) (cp-float (y point))))
      (apply #'call-next-method this
             :handle (make-shape-handle (claw:with-float-traps-masked ()
                                          (%cp:poly-shape-new (body-handle-or-static universe body)
                                                              point-count
                                                              f-points
                                                              f-transform
                                                              (cp-float 0.0001))))
             args))))


(defmethod simulation-engine-make-polygon-shape ((engine chipmunk-engine) (universe universe)
                                                 points &key body substance)
  (let ((shape (make-instance 'polygon-shape
                              :universe universe
                              :points points
                              :substance substance
                              :body body)))
    (%cp:space-add-shape (handle-value-of universe) (handle-value-of shape))
    shape))

;;;
;;; BOX
;;;
(defclass box-shape (chipmunk-shape) ())


(defmethod initialize-instance ((this box-shape) &rest args
                                &key width height body universe &allow-other-keys)
  (apply #'call-next-method this
         :handle (make-shape-handle (%cp:box-shape-new (body-handle-or-static universe body)
                                                       (cp-float width)
                                                       (cp-float height)
                                                       (cp-float 0)))
         args))


(defmethod simulation-engine-make-box-shape ((engine chipmunk-engine) (universe universe)
                                             (width number) (height number) &key body offset substance)
  (if offset
      (flet ((offset (point)
               (add point offset)))
        (simulation-engine-make-polygon-shape engine universe
                                              (mapcar #'offset (list (vec2 0 0)
                                                                     (vec2 0 height)
                                                                     (vec2 width height)
                                                                     (vec2 width 0)))
                                              :body body))
      (let ((shape (make-instance 'box-shape
                                  :universe universe
                                  :substance substance
                                  :width width
                                  :height height
                                  :ofsset offset
                                  :body body)))
        (%cp:space-add-shape (handle-value-of universe) (handle-value-of shape))
        shape)))
