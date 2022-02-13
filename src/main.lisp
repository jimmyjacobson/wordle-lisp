;; main.lisp

(in-package :com.jimmyjacobson.games.wordle)
(load "./load.lisp")

(defvar *default-words* (uiop:read-file-lines "../data/words-easy.txt"))

(defun make-game (&key (words *default-words*) (player (make-instance 'human)))
  (let ((wordle (make-instance 'game
                               :words words
                               :player player)))
    (init-game wordle)
    (play wordle))) 
