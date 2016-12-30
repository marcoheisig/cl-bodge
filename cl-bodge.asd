(in-package :cl-user)

(defpackage :cl-bodge.asdf
  (:use :cl :asdf))

(in-package :cl-bodge.asdf)

(defsystem cl-bodge/utils
  :description "Bodacious Game Engine random utilities"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (alexandria uiop log4cl local-time dissect split-sequence)
  :pathname "utils"
  :serial t
  :components ((:file "packages")
               (:file "utils")))


(defsystem cl-bodge/engine
  :description "Bodacious Game Engine foundation library"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/utils cl-muth rtg-math log4cl bordeaux-threads local-time
                              trivial-garbage uiop cffi)
  :pathname "engine"
  :serial t
  :components ((:file "packages")
               (:module math
                        :serial t
                        :components ((:file "types")
                                     (:file "scalar")
                                     (:file "vector")
                                     (:file "matrix")
                                     (:file "matvec")
                                     (:file "quaternion")))
               (:module memory
                        :serial t
                        :components ((:file "disposable")))
               (:module concurrency
                        :serial t
                        :components ((:file "dispatch")
                                     (:file "transform-dispatch")
                                     (:file "dispatched-defun")
                                     (:file "execution")
                                     (:file "job-queue")
                                     (:file "instance-lock")))
               (:file "properties")
               (:file "engine")
               (:file "generic-system")
               (:file "thread-bound-system")))


(defsystem cl-bodge/assets
  :description "Bodacious Game Engine assets system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils log4cl asdf)
  :pathname "assets"
  :serial t
  :components ((:file "packages")
               (:file "assets")
               (:file "graphics")
               (:file "audio")
               (:file "registry")
               (:file "distribution")
               (:file "system")))


(defsystem cl-bodge/events
  :description "Bodacious Game Engine event system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils log4cl)
  :pathname "events"
  :serial t
  :components ((:file "packages")
               (:file "event")
               (:file "system")))


(defsystem cl-bodge/host
  :description "Bodacious Game Engine host system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/events cl-glfw3 log4cl bordeaux-threads
                               cl-muth trivial-main-thread)
  :pathname "host"
  :serial t
  :components ((:file "packages")
               (:file "events")
               (:file "system")))


(defsystem cl-bodge/graphics
  :description "Bodacious Game Engine graphics system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/host cl-bodge/assets cl-opengl
                               log4cl local-time cffi)
  :pathname "graphics"
  :serial t
  :components ((:file "packages")
               (:file "gl")
               (:file "buffers")
               (:file "vertex-array")
               (:file "mesh")
               (:file "shading")
               (:file "textures")
               (:file "framebuffer")
               (:file "state")
               (:file "shader-source")
               (:file "shader-library")
               (:file "shading-program")
               (:file "shader-loader")
               (:module shaders
                        :components
                        ((:file "math")
                         (:file "lighting")))
               (:file "system")))


(defsystem cl-bodge/canvas
  :description "Bodacious Game Engine vector graphics system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics log4cl bodge-nanovg)
  :pathname "canvas"
  :serial t
  :components ((:file "packages")
               (:file "canvas")))


(defsystem cl-bodge/animation
  :description "Bodacious Game Engine animation library"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics)
  :pathname "animation"
  :serial t
  :components ((:file "packages")
               (:file "keyframed")
               (:module shaders
                        :components
                        ((:file "skinning")))))


(defsystem cl-bodge/audio
  :description "Bodacious Game Engine audio system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/host cl-bodge/assets log4cl
                               cl-openal cl-alc)
  :pathname "audio"
  :serial t
  :components ((:file "packages")
               (:file "al")
               (:file "buffer")
               (:file "source")
               (:file "system")))


(defsystem cl-bodge/physics
  :description "Bodacious Game Engine physics system"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine bodge-ode log4cl cl-autowrap cl-plus-c local-time)
  :pathname "physics"
  :serial t
  :components ((:file "packages")
               (:file "ode")
               (:file "universe")
               (:file "system")
               (:file "mass")
               (:file "rigid-body")
               (:file "joints")
               (:file "geometry")))


(defsystem cl-bodge/text
  :description "Bodacious Game Engine text rendering"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics cl-bodge/assets log4cl
                               cl-bodge/assets)
  :pathname "text"
  :serial t
  :components ((:file "packages")
               (:file "font")
               (:file "text")
               (:module shaders
                        :components
                        ((:file "text")))))


(defsystem cl-bodge/poiu
  :description "Bodacious Game Engine Plain Old Interface for Users"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics bodge-nuklear cl-bodge/text
                               cl-bodge/canvas cl-autowrap cl-plus-c cl-bodge/assets)
  :pathname "poiu"
  :serial t
  :components ((:file "packages")
               (:file "poiu")
               (:file "text-renderer")
               (:file "rendering-backend")
               (:module shaders
                        :components ((:file "text")))))


(defsystem cl-bodge/resources
  :description "Bodacious Game Engine .BRF resource handling"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/assets cl-bodge/graphics
                               cl-bodge/animation flexi-streams log4cl cl-fad
                               bodge-sndfile opticl)
  :pathname "resources"
  :serial t
  :components ((:file "packages")
               (:file "audio")
               (:file "resource-loader")
               (:file "basic-chunks")
               (:file "simple-model-chunk")
               (:file "image")
               (:file "font")
               (:file "converters")))


(defsystem cl-bodge/scenegraph
  :description "Bodacious Game Engine scenegraph implementation"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics cl-bodge/physics
                               cl-bodge/host cl-muth cl-bodge/animation cl-bodge/assets
                               cl-bodge/audio cl-bodge/resources)
  :pathname "scene"
  :serial t
  :components ((:file "packages")
               (:file "node")
               (:file "scene")
               (:file "simulation")
               (:file "rendering")
               (:file "transformations")
               (:file "animation")
               (:file "model")))


(defsystem cl-bodge/distribution
  :description "Bodacious Game Engine distribution helpers"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (alexandria asdf uiop cl-fad cffi split-sequence)
  :pathname "distribution"
  :serial t
  :components ((:file "packages")
               (:file "utils")
               (:file "distribution")
               #+darwin
               (:file  "build-darwin")
               #+(and unix (not darwin))
               (:file "build-unix")
               #-(or darwin unix)
               (:file "build-unknown")
               (:file "build")
               (:static-file "build.sh")))


(defsystem cl-bodge/tests
  :description "Test suite for cl-bodge engine"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils fiveam)
  :pathname "t/"
  :serial t
  :components ((:file "packages")
               (:module concurrency
                        :serial t
                        :components ((:file "suite")
                                     (:file "dispatch")))))


(defsystem cl-bodge
  :description "Bodacious Game Engine framework"
  :version "0.3.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/events cl-bodge/host
                               cl-bodge/graphics cl-bodge/audio cl-bodge/physics
                               cl-bodge/resources cl-bodge/assets cl-bodge/scenegraph
                               cl-bodge/poiu cl-bodge/text cl-bodge/canvas)
  :components ((:file "packages")))
