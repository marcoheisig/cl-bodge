(ge.util:define-package :cl-bodge.text
  (:nicknames :ge.text)
  (:use :cl :cl-bodge.utils :cl-bodge.engine :cl-bodge.graphics :cl-bodge.resources)
  (:export make-glyph
           bake-font
           font-ascender-height
           font-descender-height
           font-line-gap

           measure-string
           make-text
           render-text
           string-of
           width-of
           height-of

           make-text-renderer
           measure-scaled-string
           text-line-height
           text-ascender-height
           update-text-renderer-canvas-size
           print-text
           scale-of
           font-of))
