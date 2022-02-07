;;; game.lisp

(in-package :com.jimmyjacobson.games.wordle)

(defclass game ()
    ((name)
     (words
      :initarg :words)
     (target
      :initform nil)
     (player
      :initform nil
      :initarg :player)
     (player-prompt
      :initarg :player-prompt
      :initform "Enter a five letter word: ")
     (max-turn
      :initarg :max-turn
      :initform 6)))

(defmethod init-game (game)
  (let ((words (slot-value game 'words)))
    (setf (slot-value game 'target) (elt words (random (length words))))))

(defun play (game)
  ;; Main Game loop, requires in instance of game
  ;; local game state
  (let ((player (slot-value game 'player))
        (player-prompt (slot-value game 'player-prompt))
        (words (slot-value game 'words)) 
        (target (slot-value game 'target))
        (feedback nil)
        (guess nil))
    ;; game loop
    (dotimes (turn (slot-value game 'max-turn)) 
      (setf guess (prompt-input player-prompt words player))
      (setf feedback (check-word guess target))
      (format-feedback guess feedback)
      (cond ((string= guess target)
             (format t "Winner, Winner Chicken Dinner~%")
             (return))
            (t nil)))
    (format t "The word was ~a~%" target)))


;;; Helper Functions

;;; - scratch - helpers from a previous attempt
(defconstant HIT #\U1F7E9) ;valid character, valid position
(defconstant ALMOST #\U1F7E8) ;valid character, invalid position
(defconstant MISS #\U2B1C) ;invalid character

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

(defun format-feedback (guess feedback)
  (let ((g (ppcre:split "" guess))
        (f (ppcre:split "" feedback)))
    (format t "~{~3a~}~%~{~2a~}~%" g f)))
