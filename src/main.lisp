;; main.lisp

(in-package :com.jimmyjacobson.games.wordle)
(load "./load.lisp")

(defvar *default-words* (uiop:read-file-lines "../data/words-easy.txt"))
(defvar *hard-words* (uiop:read-file-lines "../data/words.txt"))

(defun make-game (&key (words *default-words*) (player (make-instance 'human)))
  (init-agent player)
  (let ((wordle (make-instance 'game
                               :words words
                               :player player)))
    (init-game wordle)
    (play wordle))) 


;;; Test making a random bot and running it 100 times

(setf random-strategy #'(lambda () (elt *hard-words*
                                          (random (length *hard-words*)))))

(setf *rando-bot* (make-instance 'bot
                                   :name "rando-bot"
                                   :strategy random-strategy))


(loop for n from 0 to 100
      do (let ((wordle (make-instance 'game
                                      :words *hard-words*
                                      :player *rando-bot*)))
           (init-game wordle)
           (play wordle))) 
