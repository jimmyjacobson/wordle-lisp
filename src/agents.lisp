;;; agents.lisp

(in-package :com.jimmyjacobson.games.wordle)

(defclass agent ()
  ((name
    :initarg :name
    :initform "Default")
   (wins
    :initform 0)
   (games-played
    :initform 0)))

(defgeneric init-agent (agent)
  (:documentation "generic method for initializing an agent"))

(defgeneric prompt-input (prompt words agent)
  (:documentation "generic method for prompting an input"))

(defclass bot (agent)
  ;; bots have strategies and don't require keyboard input
  ())


(defclass human (agent)
  ;; humans have different default actions than bots
  ())

(defmethod init-agent ((agent human))
  (format t "What is your name? ")
  (setf (slot-value agent 'name) (read))
  (format t "Welcome, ~a.  Let's play!~%" (slot-value agent 'name)))

(defmethod prompt-input (prompt moves (agent human))
  (format t "~a: " prompt)
  (read-line))


(defclass bot (agent)
  ;; bots have strarting words and strategies
  ((strategy ;; lambda that defines word choice funciton
   :initarg :strategy
   :initform #'(lambda () "tacos")
   )))
    

(defmethod init-agent ((agent bot))
  (declare (ignore agent)))

(defmethod prompt-input (prompt moves (agent bot))
  (declare (ignore prompt moves))
  (funcall (slot-value agent 'strategy)))
