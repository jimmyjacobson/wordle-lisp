;;; game.lisp

(in-package :com.jimmyjacobson.games.wordle)

(defclass game ()
    ((name)
     (words
      ;; data set of possible words
      :initarg :words)
     (target
      ;; index of target word
      :initform nil)
     (player
      ;; object of type 'agent'
      :initform nil
      :initarg :player)
     (player-prompt
      ;; turn prompt
      :initarg :player-prompt
      :initform "Enter a five letter word: ")
     (max-turn
      ;; self explanatory
      :initarg :max-turn
      :initform 6)
     (game-state
      ;;arbitrary list for storing game state
      :initform nil)))

(defmethod init-game (game)
  (let ((words (slot-value game 'words)))
    (setf (slot-value game 'target) (random (length words)))))

(defmethod get-word-by-index (index game)
  (let ((words (slot-value game 'words)))
    (elt words index)))

(defmethod get-index-of-word (word game)
  ;; returns index of word in words list or nil if does not exist
  (let ((words (slot-value game 'words)))
    (position word words :test #'string=)))

(defmethod write-game-results (game)
  (let ((path (make-pathname
               :directory '(:relative ".." "saves")
               :name (format nil "~a"
                             (slot-value (slot-value game 'player) 'name))
               :type "txt")))
  (with-open-file (out path
                       :direction :output
                       :if-does-not-exist :create
                       :if-exists :append)
    (with-standard-io-syntax
      (print (slot-value game 'game-state) out)))))

(defun play (game) ;TODO - change to defmethod
  ;; Main Game loop, requires in instance of game
  ;; local game state
  (let ((player (slot-value game 'player))
        (player-prompt (slot-value game 'player-prompt))
        (words (slot-value game 'words)) 
        (target (slot-value game 'target))
        (feedback nil)
        (guess nil))
    ;; game loop
    (push target (slot-value game 'game-state))
    (dotimes (turn (slot-value game 'max-turn))
      ;;loop on guess until not null (valid word)
      (loop for input = (get-index-of-word
                         (prompt-input player-prompt words player)
                         game)
            until (not (null input))
            do (format t "Not in word list~%")
            finally (setf guess input))
      (push guess (slot-value game 'game-state)) ;; save guess in game state
      (setf feedback (check-word (get-word-by-index guess game)
                                 (get-word-by-index target game)))
      (format-feedback (get-word-by-index guess game) feedback)
      ;; check for win, replace with function later
      (cond ((eql guess target)
             (format t "Winner, Winner Chicken Dinner~%")
             (return)) ; return if game over because of win
            (t nil))
      (setf guess nil))
    (format t "The word was ~a~%" (get-word-by-index target game))
    ;; playing around with output game state for learning
    (write-game-results game)))


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
