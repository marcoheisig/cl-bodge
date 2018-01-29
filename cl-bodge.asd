(asdf:defsystem cl-bodge/utils
  :description "Bodacious Game Engine various utilities"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (alexandria uiop log4cl local-time dissect split-sequence cffi
                          claw static-vectors trivial-gray-streams)
  :pathname "utils/"
  :serial t
  :components ((:file "packages")
               (:file "utils")
               (:file "language")
               (:file "collections")
               (:file "foreign")
               (:file "strings")
               (:file "trees")
               (:file "arrays")
               (:file "streams")))


(asdf:defsystem cl-bodge/engine
  :description "Bodacious Game Engine foundation library"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/utils cl-muth rtg-math log4cl bordeaux-threads local-time
                              bodge-blobs-support trivial-garbage uiop cffi cl-flow uiop
                              trivial-main-thread simple-flow-dispatcher)
  :pathname "engine/"
  :serial t
  :components ((:file "packages")
               (:module math
                        :serial t
                        :components ((:file "types")
                                     (:file "scalar")
                                     (:file "vector")
                                     (:file "matrix")
                                     (:file "quaternion")))
               (:module memory
                        :serial t
                        :components ((:file "disposable")
                                     (:file "foreign-array")))
               (:module concurrency
                        :serial t
                        :components ((:file "dispatch")
                                     (:file "execution")
                                     (:file "task-queue")
                                     (:file "instance-lock")
                                     (:file "main-thread")))
               (:module resources
                        :components ((:file "audio")
                                     (:file "graphics")))
               (:module events
                        :components ((:file "event")
                                     (:file "emitter")
                                     (:file "listener")
                                     (:file "hub")))
               (:file "properties")
               (:file "engine")
               (:file "handle")
               (:file "event")
               (:file "generic-system")
               (:file "thread-bound-system")))


(asdf:defsystem cl-bodge/resources
  :description "Bodacious Game Engine resource management"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils flexi-streams
               opticl cl-fad chipz log4cl
               sndfile-blob bodge-sndfile)
  :pathname "resources/"
  :serial t
  :components ((:file "packages")
               (:file "storage")
               (:file "handler")
               (:file "registry")
               (:module chunked
                        :serial t
                        :components ((:file "resource")
                                     (:file "chunk")
                                     (:file "font")
                                     (:file "image")
                                     (:file "mesh")
                                     (:file "skeleton")
                                     (:file "animation")
                                     (:file "container")))
               (:file "mesh")
               (:file "skeleton")
               (:file "animation")
               (:file "audio")
               (:file "image")
               (:file "font")))


(asdf:defsystem cl-bodge/host
  :description "Bodacious Game Engine host system"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils log4cl bordeaux-threads
                               glfw-blob bodge-glfw cl-muth)
  :pathname "host/"
  :serial t
  :components ((:file "packages")
               (:file "events")
               (:file "system")
               (:file "hotkey")
               (:file "keymap")))


(asdf:defsystem cl-bodge/network
  :description "Bodacious Game Engine networking utilities"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-conspack log4cl closer-mop
                               flexi-streams trivial-gray-streams
                               async-blob bodge-async
                               claw)
  :pathname "network/"
  :serial t
  :components ((:file "packages")
               (:file "utils")
               (:file "pool-allocator")
               (:file "message")
               (:file "transport")
               (:file "channel")
               (:file "foreign-object-registry")
               (:file "system")
               (:file "socket")
               (:file "server")
               (:file "client")))


(asdf:defsystem cl-bodge/graphics
  :description "Bodacious Game Engine graphics system"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/host cl-bodge/resources
                               cl-opengl log4cl local-time cffi
                               glad-blob bodge-glad
                               static-vectors)
  :pathname "graphics/"
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
               (:file "system")))


(asdf:defsystem cl-bodge/canvas
  :description "Bodacious Game Engine vector graphics system"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics
                               cl-bodge/resources claw log4cl
                               nanovg-blob bodge-nanovg)
  :pathname "canvas/"
  :serial t
  :components ((:file "packages")
               (:file "canvas")
               (:file "transform")
               (:file "image")
               (:file "paint")
               (:file "primitives")
               (:file "text")))


(asdf:defsystem cl-bodge/animation
  :description "Bodacious Game Engine animation library"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/resources cl-bodge/graphics)
  :pathname "animation/"
  :serial t
  :components ((:file "packages")
               (:file "keyframed")
               (:file "stream")
               (:file "resources")))


(asdf:defsystem cl-bodge/audio
  :description "Bodacious Game Engine audio system"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/host log4cl
                               openal-blob bodge-openal)
  :pathname "audio/"
  :serial t
  :components ((:file "packages")
               (:file "al")
               (:file "buffer")
               (:file "source")
               (:file "system")))


(asdf:defsystem cl-bodge/physics
  :description "Bodacious Game Engine physics system"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :defsystem-depends-on (bodge-blobs)
  :depends-on (cl-bodge/engine bodge-ode log4cl claw local-time)
  :pathname "physics/"
  :serial t
  :components ((:file "packages")
               (:file "ode")
               (:file "contacts")
               (:file "universe")
               (:file "system")
               (:file "mass")
               (:file "rigid-body")
               (:file "joints")
               (:file "geometry")))


(asdf:defsystem cl-bodge/shading-library
  :description "Bodacious Game Engine shading library"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/resources cl-bodge/graphics flexi-streams)
  :pathname "library/shading/"
  :serial t
  :components ((:file "packages")
               (:file "lighting")
               (:file "shader-source")
               (:file "shader-library")
               (:file "shading-program")
               (:module shaders
                        :components
                        ((:file "math")
                         (:file "lighting")
                         (:file "banner")
                         (:file "skinning")))))


(asdf:defsystem cl-bodge/text
  :description "Bodacious Game Engine text rendering"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/resources
                               cl-bodge/graphics cl-bodge/shading-library
                               log4cl)
  :pathname "text/"
  :serial t
  :components ((:file "packages")
               (:file "font")
               (:file "text")
               (:file "rated-queue")
               (:file "text-cache")
               (:module shaders
                        :components ((:file "text-program/text")
                                     (:file "text-library/text")))
               (:file "text-renderer")
               (:file "resources")))


(asdf:defsystem cl-bodge/ui
  :description "Bodacious Game Engine Plain Old Interface for Users"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics cl-bodge/canvas
                               nuklear-blob bodge-nuklear claw)
  :pathname "ui/"
  :serial t
  :components ((:file "packages")
               (:file "ui")
               (:file "events")
               (:file "elements")
               (:file "rendering-backend")))


(asdf:defsystem cl-bodge/scenegraph
  :description "Bodacious Game Engine scenegraph implementation"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/graphics cl-bodge/physics
                               cl-bodge/host cl-muth cl-bodge/animation
                               cl-bodge/audio cl-bodge/shading-library)
  :pathname "scene/"
  :serial t
  :components ((:file "packages")
               (:file "node")
               (:file "scene")
               (:file "simulation")
               (:module rendering
                        :serial t
                        :components ((:file "rendering-pass")
                                     (:file "shading")
                                     (:file "texturing")
                                     (:file "lighting")
                                     (:file "mesh")
                                     (:file "banner")))
               (:file "transformations")
               (:file "animation")
               (:file "model")))


(asdf:defsystem cl-bodge/distribution
  :description "Bodacious Game Engine distribution helpers"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/utils cl-bodge/resources asdf uiop cl-fad cffi cl-ppcre
                              bodge-blobs-support inferior-shell split-sequence flexi-streams)
  :pathname "distribution/"
  :serial t
  :components ((:file "packages")
               (:file "utils")
               (:file "distribution")
               (:file "registry")
               (:module darwin
                        :if-feature :darwin
                        :components ((:file "build")))
               (:module unix
                        :if-feature (:and :unix (:not :darwin))
                        :components ((:file "build")))
               (:module windows
                        :if-feature (:or :windows :win32)
                        :components ((:file "build")))
               (:file "build-unknown" :if-feature (:not (:or :darwin :unix :win32 :windows)))
               (:file "build")))


(asdf:defsystem cl-bodge/tests
  :description "Test suite for cl-bodge engine"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/text cl-bodge/network cl-bodge/utils flexi-streams fiveam)
  :pathname "t/"
  :serial t
  :components ((:file "packages")
               (:file "suites")
               (:file "rated-queue")
               (:file "network")
               (:file "circular-buffer")
               (:file "buffered-output-stream")))


(asdf:defsystem cl-bodge
  :description "Bodacious Game Engine framework"
  :version "0.4.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (cl-bodge/engine cl-bodge/utils cl-bodge/host cl-bodge/network
                               cl-bodge/graphics cl-bodge/audio cl-bodge/physics
                               cl-bodge/resources cl-bodge/scenegraph
                               cl-bodge/ui cl-bodge/text cl-bodge/canvas)
  :components ((:file "packages")))
