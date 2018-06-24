(cl:in-package :cl-bodge.graphics)


(defun render (output pipeline &rest input
               &key index-buffer
                 (instance-count 1)
                 vertex-count
                 (vertex-offset 0)
               &allow-other-keys)
  (enable-rendering-output output)
  (enable-pipeline pipeline input)
  (let ((mode (pipeline-primitive pipeline)))
    (if index-buffer
        (progn
          (inject-shader-input index-buffer)
          (%gl:draw-elements-instanced mode
                                       (or vertex-count (index-buffer-length index-buffer))
                                       :unsigned-int
                                       (cffi:make-pointer vertex-offset)
                                       instance-count))
        (%gl:draw-arrays-instanced mode vertex-offset vertex-count instance-count))))
