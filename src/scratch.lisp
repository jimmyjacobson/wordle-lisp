
(setf robot (make-instance 'bot :strategy #'(Lambda () (elt *default-words* (random (length *default-words*))))))
