;;; swank-sprof.lisp
;;
;; Authors: Juho Snellman
;;
;; License: MIT
;;

(in-package :swank)

#+sbcl(progn

#.(prog1 nil (require :sb-sprof))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :sb-sprof))

(defvar *call-graph* nil)
(defvar *node-numbers* nil)
(defvar *number-nodes* nil)

(defun pretty-name (name)
  (let ((*package* (find-package :common-lisp-user))
        (*print-right-margin* most-positive-fixnum))
    (format nil "~S" (if (consp name)
                         (let ((head (car name)))
                           (if (or (eq head 'sb-c::tl-xep)
                                   (eq head 'sb-c::hairy-arg-processor)
                                   (eq head 'sb-c::top-level-form)
                                   (eq head 'sb-c::xep))
                               (cadr name)
                               name))
                         name))))

(defun samples-percent (count)
  (sb-sprof::samples-percent *call-graph* count))

(defun node-values (node)
  (values (pretty-name (sb-sprof::node-name node))
          (samples-percent (sb-sprof::node-count node))
          (samples-percent (sb-sprof::node-accrued-count node))))

(defun serialize-call-graph ()
  (let ((nodes (sort (copy-list
                      (sb-sprof::call-graph-flat-nodes *call-graph*))
                     #'>
;;                     :key #'sb-sprof::node-count)))
                     :key #'sb-sprof::node-accrued-count)))
    (setf *number-nodes* (make-hash-table))
    (setf *node-numbers* (make-hash-table))
    (loop for node in nodes
          for i from 1
          with total = 0
          collect (multiple-value-bind (name self cumulative)
                      (node-values node)
                    (setf (gethash node *node-numbers*) i
                          (gethash i *number-nodes*) node)
                    (incf total self)
                    (list i name self cumulative total)) into list
          finally (return
                    (let ((rest (- 100 total)))
                      (return (append list
                                      `((nil "Elsewhere" ,rest nil nil)))))))))

(defslimefun swank-sprof-get-call-graph ()
  (setf *call-graph* (sb-sprof:report :type nil))
  (serialize-call-graph))


(defslimefun swank-sprof-expand-node (index)
  (let* ((node (gethash index *number-nodes*)))
    (labels ((caller-count (v)
               (loop for e in (sb-sprof::vertex-edges v) do
                     (when (eq (sb-sprof::edge-vertex e) node)
                       (return-from caller-count (sb-sprof::call-count e))))
               0)
             (serialize-node (node count)
               (etypecase node
                 (sb-sprof::cycle
                  (list (sb-sprof::cycle-index node)
                        (sb-sprof::cycle-name node)
                        (samples-percent count)))
                 (sb-sprof::node
                  (let ((name (node-values node)))
                    (list (gethash node *node-numbers*)
                          name
                          (samples-percent count)))))))
      (list :callers (let ((edges (sort (copy-list (sb-sprof::node-callers node))
                                        #'>
                                        :key #'caller-count)))
                       (loop for node in edges
                             collect (serialize-node node
                                                     (caller-count node))))
            :calls (let ((edges (sort (copy-list (sb-sprof::vertex-edges node))
                                      #'>
                                      :key #'sb-sprof::call-count)))
                     (loop for edge in edges
                           collect
                           (serialize-node (sb-sprof::edge-vertex edge)
                                           (sb-sprof::call-count edge))))))))

(defslimefun swank-sprof-disassemble (index)
  (let* ((node (gethash index *number-nodes*))
         (debug-info (sb-sprof::node-debug-info node)))
    (with-output-to-string (s)
      (typecase debug-info
        (sb-impl::code-component
         (sb-disassem::disassemble-memory (sb-vm::code-instructions debug-info)
                                          (sb-vm::%code-code-size debug-info)
                                          :stream s))
        (sb-di::compiled-debug-fun
         (let ((component (sb-di::compiled-debug-fun-component debug-info)))
           (sb-disassem::disassemble-code-component component :stream s)))
        (t `(:error "No disassembly available"))))))

(defslimefun swank-sprof-source-location (index)
  (let* ((node (gethash index *number-nodes*))
         (debug-info (sb-sprof::node-debug-info node)))
    (or (when (typep debug-info 'sb-di::compiled-debug-fun)
          (let* ((component (sb-di::compiled-debug-fun-component debug-info))
                 (function (sb-kernel::%code-entry-points component)))
            (when function
              (find-source-location function))))
        `(:error "No source location available"))))

(defslimefun swank-sprof-start ()
  (sb-sprof:start-profiling))

(defslimefun swank-sprof-stop ()
  (sb-sprof:stop-profiling))

)

(provide :swank-sprof)