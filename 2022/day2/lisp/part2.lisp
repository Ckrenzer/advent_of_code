(defun main (argv)
  (declare (ignore argv))
  (let ((values (list #\A 1 #\B 2 #\C 3))
        (counters (list #\A #\B
                        #\B #\C
                        #\C #\A
                        #\X #\B
                        #\Y #\C
                        #\Z #\A)))
    (dolist (file-name (list "example.txt" "input.txt"))
      (let ((score))
        (setf score
              (with-open-file (infile file-name :direction :input)
                (do ((opponent-value) (my-value) (total-score 0))
                  (nil)
                  (setf opponent-value (read-char infile nil nil))
                  (if (eq opponent-value nil) (return total-score) (read-char infile nil nil)) ;; return or skip delimiter
                  (setf my-value (read-char infile nil nil))
                  (cond
                    ((char= my-value #\X) (incf total-score (getf values (getf counters (getf counters opponent-value))))) ; lose
                    ((char= my-value #\Y) (incf total-score (+ (getf values opponent-value) 3)))                           ; draw
                    ((char= my-value #\Z) (incf total-score (+ (getf values (getf counters opponent-value)) 6))))          ; win
                  (read-char infile nil nil) ;; move to the next line
                  )
                )
              )
        (format t "Score: ~a~%" score)
        )
      )
    )
  )
