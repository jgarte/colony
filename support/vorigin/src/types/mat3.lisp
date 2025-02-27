(in-package #:cl-user)

(defpackage #:vorigin.mat3
  (:local-nicknames
   (#:com #:vorigin.common)
   (#:m2 #:vorigin.mat2)
   (#:u #:vutils)
   (#:v2 #:vorigin.vec2)
   (#:v3 #:vorigin.vec3))
  (:use #:cl)
  (:shadow
   #:=
   #:+
   #:-
   #:*
   #:random
   #:trace)
  (:export
   #:mat
   #:with-components
   #:pretty-print
   #:+zero+
   #:+id+
   #:zero
   #:zero!
   #:zero-p
   #:id
   #:id!
   #:id-p
   #:=
   #:random!
   #:random
   #:copy!
   #:copy
   #:clamp!
   #:clamp
   #:clamp-range!
   #:clamp-range
   #:+!
   #:+
   #:-!
   #:-
   #:*!
   #:*
   #:get-column!
   #:get-column
   #:set-column!
   #:set-column
   #:get-translation!
   #:get-translation
   #:set-translation!
   #:set-translation
   #:translate!
   #:translate
   #:copy-rotation!
   #:copy-rotation
   #:rotation-to-mat2!
   #:rotation-to-mat2
   #:normalize-rotation!
   #:normalize-rotation
   #:rotation-axis-to-vec2!
   #:rotation-axis-to-vec2
   #:rotation-axis-from-vec2!
   #:rotation-axis-from-vec2
   #:rotation-x-from-angle!
   #:rotation-x-from-angle
   #:rotation-y-from-angle!
   #:rotation-y-from-angle
   #:rotation-z-from-angle!
   #:rotation-z-from-angle
   #:rotate!
   #:rotate
   #:get-scale!
   #:get-scale
   #:set-scale!
   #:set-scale
   #:scale!
   #:scale
   #:*v3!
   #:*v3
   #:transpose!
   #:transpose
   #:orthogonal-p
   #:trace
   #:diagonal-p
   #:main-diagonal!
   #:main-diagonal
   #:anti-diagonal!
   #:anti-diagonal
   #:set-diagonal!
   #:set-diagonal
   #:determinant
   #:invert!
   #:invert))

(in-package #:vorigin.mat3)

(deftype mat () '(u:f32a 9))

(defmacro with-components (((prefix matrix) &rest rest) &body body)
  (u:once-only (matrix)
    `(symbol-macrolet
         ((,prefix ,matrix)
          (,(com:make-accessor-symbol prefix "00") (aref ,matrix 0))
          (,(com:make-accessor-symbol prefix "10") (aref ,matrix 1))
          (,(com:make-accessor-symbol prefix "20") (aref ,matrix 2))
          (,(com:make-accessor-symbol prefix "01") (aref ,matrix 3))
          (,(com:make-accessor-symbol prefix "11") (aref ,matrix 4))
          (,(com:make-accessor-symbol prefix "21") (aref ,matrix 5))
          (,(com:make-accessor-symbol prefix "02") (aref ,matrix 6))
          (,(com:make-accessor-symbol prefix "12") (aref ,matrix 7))
          (,(com:make-accessor-symbol prefix "22") (aref ,matrix 8)))
       ,(if rest
            `(with-components ,rest ,@body)
            `(progn ,@body)))))

(defun pretty-print (matrix &optional (stream *standard-output*))
  (with-components ((m matrix))
    (format stream "[~,6f, ~,6f, ~,6f~% ~,6f, ~,6f, ~,6f~% ~,6f, ~,6f, ~,6f]"
            m00 m01 m02 m10 m11 m12 m20 m21 m22)))

;;; Constructor

(u:fn-> mat (u:f32 u:f32 u:f32 u:f32 u:f32 u:f32 u:f32 u:f32 u:f32) mat)
(declaim (inline mat))
(u:eval-always
  (defun mat (m00 m10 m20 m01 m11 m21 m02 m12 m22)
    (declare (optimize speed))
    (let ((mat (u:make-f32-array 9)))
      (setf (aref mat 0) m00
            (aref mat 1) m10
            (aref mat 2) m20
            (aref mat 3) m01
            (aref mat 4) m11
            (aref mat 5) m21
            (aref mat 6) m02
            (aref mat 7) m12
            (aref mat 8) m22)
      mat)))

;;; Constants

(u:define-constant +zero+ (mat 0f0 0f0 0f0 0f0 0f0 0f0 0f0 0f0 0f0) :test #'equalp)

(u:define-constant +id+ (mat 1f0 0f0 0f0 0f0 1f0 0f0 0f0 0f0 1f0) :test #'equalp)
