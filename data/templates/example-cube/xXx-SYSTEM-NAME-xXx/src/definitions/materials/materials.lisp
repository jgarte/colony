(in-package #:xXx-SYSTEM-NAME-xXx)

(c:define-material v-letter
  (:shader shd:unlit-texture
   :profiles (x:u-mvp)
   :uniforms
   ((:tex.sampler1 'v-letter)
    (:mix-color (v4:ones)))))

(c:define-material v-letter-invert
  (:shader shd:unlit-texture-invert
   :profiles (x:u-mvp)
   :uniforms
   ((:tex.sampler1 'v-letter)
    (:mix-color (v4:ones)))))
