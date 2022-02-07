;; main.lisp

(in-package :com.jimmyjacobson.games.wordle)
(load "./load.lisp")

(defvar *default-words* (uiop:read-file-lines "../data/words-easy.txt"))

(defun make-game (&key (words *default-words*) (player 'human))
  (let ((wordle (make-instance 'game
                             :player (make-instance 'human)
                             :words words)))
    (init-game wordle)
    (play wordle)))
