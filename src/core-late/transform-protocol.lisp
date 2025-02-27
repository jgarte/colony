(in-package #:colony)

;;; NOTE: Each user protocol function below is generic for maximum flexibility.
;;; They can take 1 of 3 objects to operate on:
;;; 1. A transform component to directly manipulate.
;;; 2. An actor object, since it is assumed that actor transforms are permanent
;;; once the flows add one to an actor.
;;; 3. Any arbitrary component, in which case an attempt is made to access it's
;;; actor's transform component. In the case of a "floating" component with no
;;; actor, a runtime error is caught to prevent unintutive late errors.

;;; This flexibility will allow for less mistakes and also clean up component
;;; protocol call sites; for example, it is not always necessary to cache a copy
;;; of a transform component in a component. Users may still want to do so to
;;; minimize any overhead in finding that transform on each invocation of a
;;; transform API call, but we shouldn't force them to.

(defgeneric get-model-matrix (object &key)
  (:method ((object comp:transform) &key copy)
    (comp::%get-model-matrix object copy))
  (:method ((object actor) &key copy)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%get-model-matrix transform copy)))
  (:method ((object component) &key copy)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%get-model-matrix transform copy))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric get-translation (object &key)
  (:method ((object comp:transform) &key (space :local))
    (comp::%get-translation object space))
  (:method ((object actor) &key (space :local))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%get-translation transform space)))
  (:method ((object component) &key (space :local))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%get-translation transform space))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric get-rotation (object &key)
  (:method ((object comp:transform) &key (space :local))
    (comp::%get-rotation object space))
  (:method ((object actor) &key (space :local))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%get-rotation transform space)))
  (:method ((object component) &key (space :local))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%get-rotation transform space))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric get-scale (object &key)
  (:method ((object comp:transform) &key (space :local))
    (comp::%get-scale object space))
  (:method ((object actor) &key (space :local))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%get-scale transform space)))
  (:method ((object component) &key (space :local))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%get-scale transform space))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric translate (object vec &key)
  (:method ((object comp:transform) vec &key (space :local) replace instant)
    (comp::%translate object vec space replace instant))
  (:method ((object actor) vec &key (space :local) replace instant)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%translate transform vec space replace instant)))
  (:method ((object component) vec &key (space :local) replace instant)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%translate transform vec space replace instant))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric translate/velocity (object axis rate)
  (:method ((object comp:transform) axis rate)
    (comp::%translate/velocity object axis rate))
  (:method ((object actor) axis rate)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%translate/velocity transform axis rate)))
  (:method ((object component) axis rate)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%translate/velocity transform axis rate))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric rotate (object quat &key)
  (:method ((object comp:transform) quat &key (space :local) replace instant)
    (comp::%rotate object quat space replace instant))
  (:method ((object actor) quat &key (space :local) replace instant)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%rotate transform quat space replace instant)))
  (:method ((object component) quat &key (space :local) replace instant)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%rotate transform quat space replace instant))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric rotate/velocity (object axis rate)
  (:method ((object comp:transform) axis rate)
    (comp::%rotate/velocity object axis rate))
  (:method ((object actor) axis rate)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%rotate/velocity transform axis rate)))
  (:method ((object component) axis rate)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%rotate/velocity transform axis rate))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric scale (object vec &key)
  (:method ((object comp:transform) vec &key (space :local) replace instant)
    (comp::%scale object vec space replace instant))
  (:method ((object actor) vec &key (space :local) replace instant)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%scale transform vec space replace instant)))
  (:method ((object component) vec &key (space :local) replace instant)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%scale transform vec space replace instant))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric scale-around (object pivot-in-world scale-vec &key)
  (:method ((object comp:transform) pivot-in-world scale-vec &key)
    (comp::%scale-around object pivot-in-world scale-vec))
  (:method ((object actor) pivot-in-world scale-vec &key)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%scale-around transform pivot-in-world scale-vec)))
  (:method ((object component) pivot-in-world scale-vec &key)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%scale-around transform pivot-in-world scale-vec))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric scale/velocity (object axis rate)
  (:method ((object comp:transform) axis rate)
    (comp::%scale/velocity object axis rate))
  (:method ((object actor) axis rate)
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%scale/velocity transform axis rate)))
  (:method ((object component) axis rate)
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%scale/velocity transform axis rate))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-point (object point &key)
  (:documentation "Transform the vector in POINT, assumed to be in the local
space of the TRANSFORM, to world space and returns the new vector. The new
vector is affected by scale, rotation, and translation. A newly allocated M:VEC3
is returned.")
  (:method ((object comp:transform) point &key (space :local))
    (comp::%transform-point object point space))
  (:method ((object actor) point &key (space :local))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-point transform point space)))
  (:method ((object component) point &key (space :local))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-point transform point space))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-vector (object vector &key)
  (:documentation "Transform the vector in VECTOR, assumed to be in the local
space of the TRANSFORM, to world space and return it. The new vector is affected
by scale and rotation, but not by translation. A newly allocated M:VEC3 is
returned.")
  (:method ((object comp:transform) vector &key (space :local))
    (comp::%transform-vector object vector space))
  (:method ((object actor) vector &key (space :local))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-vector transform vector space)))
  (:method ((object component) vector &key (space :local))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-vector transform vector space))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-direction (object direction &key)
  (:documentation "Transform the vector in DIRECTION, assumed to be in the local
space of the TRANSFORM, to the world space and return it. The new vector is
affected only by rotation, and not by translation or scale. A newly allocated
M:VEC3 is returned.")
  (:method ((object comp:transform) direction &key (space :local))
    (comp::%transform-direction object direction space))
  (:method ((object actor) direction &key (space :local))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-direction transform direction space)))
  (:method ((object component) direction &key (space :local))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-direction transform direction space))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-forward (object)
  (:documentation "Return the forward vector (-Z axis) in world space for this
                  TRANSFORM.")
  (:method ((object comp:transform))
    (comp::%transform-forward object))
  (:method ((object actor))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-forward transform)))
  (:method ((object component))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-forward transform))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-backward (object)
  (:documentation "Return the backward vector (+Z axis) in world space for this
                  TRANSFORM.")
  (:method ((object comp:transform))
    (comp::%transform-backward object))
  (:method ((object actor))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-backward transform)))
  (:method ((object component))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-backward transform))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-up (object)
  (:documentation "Return the up vector (+Y axis) in world space for this
                  TRANSFORM.")
  (:method ((object comp:transform))
    (comp::%transform-up object))
  (:method ((object actor))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-up transform)))
  (:method ((object component))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-up transform))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-down (object)
  (:documentation "Return the down vector (-Y axis) in world space for this
                  TRANSFORM.")
  (:method ((object comp:transform))
    (comp::%transform-down object))
  (:method ((object actor))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-down transform)))
  (:method ((object component))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-down transform))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-right (object)
  (:documentation "Return the right vector (+X axis) in world space for this
                  TRANSFORM.")
  (:method ((object comp:transform))
    (comp::%transform-right object))
  (:method ((object actor))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-right transform)))
  (:method ((object component))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-right transform))
      (error "Component ~a is not currently attached to an actor." object))))

(defgeneric transform-left (object)
  (:documentation "Return the left vector (+X axis) in world space for this
                  TRANSFORM.")
  (:method ((object comp:transform))
    (comp::%transform-left object))
  (:method ((object actor))
    (let ((transform (component-by-type object 'comp:transform)))
      (comp::%transform-left transform)))
  (:method ((object component))
    (u:if-let ((actor (actor object)))
      (let ((transform (component-by-type actor 'comp:transform)))
        (comp::%transform-left transform))
      (error "Component ~a is not currently attached to an actor." object))))
