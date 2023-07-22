(defun split-sack (sack)
  (let ((compartment-size (/ (length sack) 2)))
    (vector (subseq sack 0 compartment-size) (subseq sack compartment-size (length sack)))))

(defun intersect (compartments)
  (let ((compartment1 (elt compartments 0)) (compartment2 (elt compartments 1)))
    (let ((len (length compartment1)) (initial-element #\0))
      (let ((shared-values (make-array len :initial-element initial-element)))
        (dotimes (i len)
          (dotimes (k (length compartment2))
            (if (char= (elt compartment1 i) (elt compartment2 k))
              (setf (elt shared-values i) (elt compartment1 i)))))
        (delete-duplicates (remove initial-element shared-values) :test #'char=)))))

(dolist (file-name (list "example.txt" "input.txt"))
  (let ((rucksacks) (matched-priority-sum 0))
    (setf rucksacks
          (with-open-file (infile file-name :direction :input)
            (do ((line "") (lines (list)))
              ((eq line nil) (nreverse lines))
              (setf line (read-line infile nil nil))
              (if (not (eq line nil))
                (setf lines (append (list line) lines))))))
    (let ((results (make-array (length rucksacks) :fill-pointer 0 :adjustable t)))
      (dolist (rucksack rucksacks)
        (setf results (concatenate 'vector (intersect (split-sack rucksack)) results)))
      (dotimes (i (length results))
        (let ((priority-value (char-code (elt results i))))
          (if (>= priority-value 97) (decf priority-value 96) (decf priority-value 38))
          (incf matched-priority-sum priority-value))))
    (format t "Sum of all priority items found in both compartments: ~a~%" matched-priority-sum)
    ))
