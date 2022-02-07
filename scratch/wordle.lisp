;;; wordle

(ql:quickload :uiop)

(defconstant HIT #\U1F7E9) ;valid character, valid position
(defconstant ALMOST #\U1F7E8) ;valid character, invalid position
(defconstant MISS #\U2B1C) ;invalid character
(defconstant WIN (format nil "~{~a~}" '(HIT HIT HIT HIT HIT))) ; this is cheating a bit
(defparameter *words* (uiop:read-file-lines "words-easy.txt"))

(defun check-word (guess target)
  (let ((response nil))
    (loop for i from 0 to (- (length target) 1)  do
      (cond
        ((equal (elt guess i) (elt target i))
         (push HIT response))
        ((not (null (position (elt guess i) target)))
         (push ALMOST response))
        (t (push MISS response))))
    (format nil "~{~a~}" (reverse response))))


(defun play-wordle ()
    (let ((target (elt *words* (random (length *words*))))
          (guess nil)
          (response nil))
      (dotimes (i 6)
        (setf guess (prompt-read "Enter Guess"))
        (setf response (check-word guess target))
        (if (string-equal response WIN)
            (return)
            (format t "~a~%" (check-word guess target))))
      (format t "The word was ~a" target)))

      


(defun prompt-read (prompt)
  ;; helper function for reading input from command line
  (format t "~a:" prompt)
  (force-output)
  (read-line))
