(defun main (argv)
  (declare (ignore argv))
  (dolist (file-name (list "example.txt" "input.txt"))
    (let ((score) (values (list #\A 1 #\X 1 #\B 2 #\Y 2 #\C 3 #\Z 3)))
      (setf score
            (with-open-file (infile file-name :direction :input)
              (do ((opponent-value #\0) (my-value #\0) (total-score 0))
                (nil)
                (setf opponent-value (read-char infile nil nil))
                (if (eq opponent-value nil) (return total-score) (read-char infile nil nil)) ;; return or skip delimiter
                (setf my-value (read-char infile nil nil))
                (incf total-score (+ (getf values my-value)
                                     (if (eql (getf values my-value) (getf values opponent-value)) 3 0)
                                     (if
                                       (or
                                         (and (char= my-value #\X) (char= opponent-value #\C))
                                         (and (char= my-value #\Y) (char= opponent-value #\A))
                                         (and (char= my-value #\Z) (char= opponent-value #\B)))
                                       6 0)))
                (read-char infile nil nil) ;; move to the next line
                )))
      (format t "Score: ~a~%" score))
    )
  )
