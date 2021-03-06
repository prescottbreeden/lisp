; location :: starting location
(defparameter *location* 'living-room)

; nodes :: locations with descriptions
(defparameter *nodes* '((living-room (you are in the living-room. a wizard is snoring loudly on the couch.))
                        (garden (you are in a beautiful garden. there is a well in front of you.))
                        (attic (you are in the attic. there is a giant welding torch in the corner.))))

; edges :: node (list (node location path))
(defparameter *edges* '((living-room (garden west door)
                                     (attic upstairs ladder))
                        (garden (living-room east door))
                        (attic (living-room downstairs ladder))))

; objects :: all objects
(defparameter *objects* '(whiskey bucket frog chain welding-torch))

; object-locations :: where objects are located
(defparameter *object-locations* '((whiskey living-room)
                                   (bucket living-room)
                                   (chain garden)
                                   (frog garen)
                                   (welding-torch attic)
                                   ))

; (defun game-repl ()
;   (let ((cmd (game-read)))
;     (unless (eq (car cmd) 'quit)
;       (game-print (game-eval dmg))
;       (game-rpl))))

(defun describe-location (location nodes)
  (cadr (assoc location nodes)))

(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

(defun objects-at (location objects object-locations)
  (labels ((at-loc-p (obj)
                     (eq (cadr (assoc obj object-locations)) location)))
    (remove-if-not #'at-loc-p objects)))

(defun describe-objects (location objects object-locations)
  (labels ((describe-obj (obj)
                         `(you see a ,obj on the floor.)))
    (apply #'append
           (mapcar #'describe-obj (objects-at location objects object-locations)))))

(defun look ()
  (append (describe-location *location* *nodes*)
          (describe-paths *location* *edges*)
          (describe-objects *location* *objects* *object-locations*)))

(defun walk (direction)
  (let ((next (find direction
                    (cdr (assoc *location* *edges*))
                    :key #'cadr)))
    (if next
      (progn (setf *location* (car next))
             (look))
      '(you cannot go that way.))))

(defun pickup (object)
  (cond ((member object (objects-at *location* *objects* *object-locations*))
         (push (list object 'body) *object-locations*)
         `(you are now carrying the ,object))
        (t '(you cannot pick that up.))))

(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))
