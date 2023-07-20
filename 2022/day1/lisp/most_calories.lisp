;; Note -- this depends on the last line of the file being a newline
(dolist (file-name (list "example.txt" "input.txt"))
  (defparameter *calories* (with-open-file (infile file-name :direction :input)
                             (do ((line "") (values (list)))
                               ((eq line nil) (nreverse (delete nil values :start 0 :end 1))) ;; delete EOF
                               (setf line (read-line infile nil nil))
                               (setf values (append (list line) values)))))

  (defparameter *max-calories*
    (let ((current-elf-calories 0) (top-calories (make-array 3)))
      (dolist (item *calories*)
        (if (string= item "")
          (progn
            (cond
              ((> current-elf-calories (elt top-calories 0))
               (progn
                 (setf (elt top-calories 2) (elt top-calories 1))
                 (setf (elt top-calories 1) (elt top-calories 0))
                 (setf (elt top-calories 0) current-elf-calories)))

              ((> current-elf-calories (elt top-calories 1))
               (progn
                 (setf (elt top-calories 2) (elt top-calories 1))
                 (setf (elt top-calories 1) current-elf-calories)))

              ((> current-elf-calories (elt top-calories 2))
               (setf (elt top-calories 2) current-elf-calories)))

            (setf current-elf-calories 0))
          (incf current-elf-calories (parse-integer item))))
      top-calories))

  (defparameter *top-three-totals*
    (let ((sum 0))
      (dotimes (i (length *max-calories*))
        (incf sum (elt *max-calories* i)))
      sum))

  (format t "<<~a>>~%" file-name)
  (format t "Total calories carried by the elf with the most calories: ~a~%" (elt *max-calories* 0))
  (format t "Total calories carried by the top three elves combined ~a~%~%" *top-three-totals*)
  )
