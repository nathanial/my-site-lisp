
(defun nml-load-paredit ()
  (autoload 'paredit-mode "paredit"
    "Minor mode for pseudo-structurally editing Lisp code."
    t))

(defun nml-load-scala ()
  (require 'scala-mode-auto))

(defun nml-add-to-load-path (directory)
  (add-to-list 'load-path (concat nathans-site-lisp directory)))

(defun nml-load-haskell ()
  (nml-add-to-load-path "haskell-mode")
  (load "haskell-mode/haskell-site-file")
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  (set-variable 'haskell-program-name "ghci -fglasgow-exts"))

(defun nml-load-ruby ()
  (require 'ruby-mode)
  (nml-add-to-load-path "ruby-mode")
  (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
  (autoload 'run-ruby "inf-ruby" "Run an inferior Ruby Process")
  (autoload 'inf-ruby-keys "inf-ruby"
    "Set local key defs for inf-ruby in ruby-mode")
  (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (inf-ruby-keys)))
  (autoload 'rubydb "rubydb3x" "Ruby debugger" t)
  (add-hook 'ruby-mode-hook 'turn-on-font-lock))

(defun nml-load-prolog ()
  (set-variable 'prolog-program-name "prolog"))

(defun nml-load-perl ()
  (add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|a1\\)\\'" . cperl-mode))
  (add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
  (add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
  (add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
  (add-hook 'cperl-mode 'n-cperl-mode-hook t)
  (defun n-cperl-mode-hook ()
    (setq cperl-indent-level 4)
    (setq cperl-continued-statement-offset 0)
    (setq cperl-extra-newline-before-brace t)
    (set-face-background 'cperl-array-face "wheat")
    (set-face-background 'cperl-hash-face "wheat")))

(defun nml-load-nxml ()
  (load "nxhtml/autostart.el")
  (global-unset-key (kbd "C-o"))
  (global-set-key (kbd "C-o C-h") 'hs-hide-block)
  (global-set-key (kbd "C-o C-s") 'hs-show-block)
  (global-set-key (kbd "C-o C-l") 'hs-hide-level)
  (global-set-key (kbd "C-o C-c") 'hs-toggle-hiding)
  (global-set-key (kbd "C-o C-a") 'hs-show-all)
  (global-set-key (kbd "C-o C-o") 'hs-hide-all)
  
  (add-hook 'nxhtml-mode-hook 
	    '(lambda ()
	       (outline-minor-mode -1))))

(defun nml-load-ioke ()
  (require 'ioke-mode))

(defun nml-load-io ()
  (add-to-list 'auto-mode-alist '("\\.io$" . io-mode)))

(defun nml-load-yasnippet ()
  (require 'yasnippet)
  (add-to-list 'yas/extra-mode-hooks 'javascript-mode-hook)
  (yas/initialize)
  (yas/load-directory "~/.emacs.d/snippets"))

(defun nml-load-caml ()
  (add-to-list 'auto-mode-alist '("\\.ml[iylp]?$" . caml-mode))
  (autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
  (autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)
  (if window-system (require 'caml-font)))

(defun nml-load-color-theme ()
  (require 'color-theme)
  (color-theme-initialize))

(defun nml-load-e-blog ()
  (load "e-blog.el"))

(defun nml-load-pymacs ()
  (autoload 'pymacs-apply "pymacs")
  (autoload 'pymacs-call "pymacs")
  (autoload 'pymacs-eval "pymacs" nil t)
  (autoload 'pymacs-exec "pymacs" nil t)
  (autoload 'pymacs-load "pymacs" nil t))

(defun nml-load-groovy ()
  (autoload 'groovy-mode "groovy-mode"
    "Mode for editing groovy source files" t)
  (add-to-list 'auto-mode-alist '("\\.\\(groovy$\\)\\|\\(gant$\\)" . groovy-mode))
  (add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))
  
  (autoload 'run-groovy "inf-groovy" "Run an inferior Groovy process")
  (autoload 'inf-groovy-keys 
    "inf-groovy" "Set local key defs for inf-groovy in groovy-mode")
  (add-hook 'groovy-mode-hook
	    '(lambda ()
	       (inf-groovy-keys)))
  (set-variable 'groovy-home "/usr/local/src/runtimes/groovy-1.6.0")
  (add-hook 'inf-groovy-load-hook 'ansi-color-for-comint-mode-on)
  (add-hook 'inferior-groovy-mode-hook 
	    '(lambda ()
	       (setq comint-process-echoes t))))

(defun nml-load-desktop ()
  (desktop-save-mode 1)
  (setq history-length 250)
  (add-to-list 'desktop-globals-to-save 'file-name-history))

(defun nml-load-custom ()
  (setq confirm-nonexistent-file-or-buffer nil)
  (put 'narrow-to-region 'disabled nil)
  ;;ui
  (setq inhibit-startup-screen t)
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  ;;completion
  (partial-completion-mode t)
  ;;shell
  (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
  ;;eshell
  (add-hook 'eshell-mode-hook
	    '(lambda nil
	       (let ((path))
		 (setq path (concat (getenv "PATH") ":/home/nathan/scripts"))
		 (setenv "PATH" path)
		 (setenv "EDITOR" "emacs"))))
  ;;outline minor mode
  (setq outline-minor-mode-prefix "\C-o")
  (setq hs-minor-mode-prefix "\C-c")
  ;;lisp
  (global-set-key "\M-?" 'lisp-complete-symbol))

(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
	   (parse-status (save-excursion (syntax-ppss (point-at-bol))))
	   (offset (- (current-column) (current-indentation)))
	   (indentation (espresso--proper-indentation parse-status))
	   node)
      (save-excursion
	(back-to-indentation)
	(if (looking-at "case\\s-")
	    (setq indentation (+ indentation (/ espresso-indent-level 2))))
	
	(setq node (js2-node-at-point))
	(when (and node
		   (= js2-NAME (js2-node-type node))
		   (= js2-VAR (js2-node-type (js2-node-parent node))))
	  (setq indentation (+ 4 indentation))))
      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
	     (parse-status (syntax-ppss (point)))
	     (beg (nth 1 parse-status))
	     (end-marker (make-marker))
	     (end (progn (goto-char beg) (forward-list) (point)))
	     (ovl (make-overlay beg end)))
	(set-marker end-marker end)
	(overlay-put ovl 'face 'highlight)
	(goto-char beg)
	(while (< (point) (mark-position end-marker))
	  (beginning-of-line)
	  (unless (looking-at "\\s-*$")
	    (indent-according-to-mode))
	  (forward-line))
	(run-with-timer 0.5 nil '(lambda (ovl)
				   (delete-overlay ovl)) ovl)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 4
	indent-tabs-mode nil
	c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)]
    '(lambda ()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion 
	 (insert " ]----- */"))))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (message "My JS2 hook"))


(defun nml-load-js2 ()
  (autoload 'js2-mode "js2-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  (autoload 'espress-mode "espresso")
  (add-hook 'js2-mode-hook 'my-js2-mode-hook))


(defun nml-load-clojure-mode ()
  (require 'clojure-mode)
  
  (nml-add-to-load-path "swank-clojure")
  (require 'swank-clojure-autoload)
  (swank-clojure-config
   (setq swank-clojure-jar-path "/opt/local/share/java/clojure/lib/clojure.jar")
   (setq swank-clojure-extra-classpaths 
	 (list "/Users/nathan/Sources/swank-clojure/swank-clojure.jar")))
  
  (eval-after-load "slime"
    '(progn (slime-setup '(slime-repl))))
  
  
  (nml-add-to-load-path "slime")  ; your SLIME directory
  (require 'slime)
  (slime-setup))

(defun nml-load-qt-mode ()
  (require 'cc-mode)
  (setq c-C++-access-key "\\<\\(slots\\|signals\\|private\\|protected\\|public\\)\\>[ \t]*[(slots\\|signals)]*[ \t]*:")
  (font-lock-add-keywords 'c++-mode '(("\\<\\(Q_OBJECT\\|public slots\\|public signals\\|private slots\\|private signals\\|protected slots\\|protected signals\\)\\>" . font-lock-constant-face))))


(defun nml-load-everything ()

  (nml-load-custom)
  (nml-load-ruby)
  (nml-load-yasnippet)

  (nml-load-nxml)
  (nml-load-js2)

  (shell)
  (put 'downcase-region 'disabled nil)

  (put 'upcase-region 'disabled nil)

  (defun my-python-def-count ()
    (let ((python-def-count 0))
      (setq python-def-count 0)
      (save-excursion
	(while (search-forward "def" nil t nil)
	  (setq python-def-count (+ python-def-count 1))))
      python-def-count))

  (defun my-cortex-autocomplete ()
    (interactive)
    (save-excursion
      (let* ((word-start (progn (backward-word) (point)))
	     (word-end (progn (forward-word) (point)))
	     (word (buffer-substring-no-properties word-start word-end)))
	(when (string-equal word "cv")
	  (delete-region word-start word-end)
	  (insert-string "CortexVariant")))))

  (add-to-list 'load-path "~/Projects/my-site-lisp/jump")
  (add-to-list 'load-path "~/Projects/my-site-lisp/rinari")
  (add-to-list 'load-path "~/Projects/my-site-lisp/yaml-mode")
  (require 'jump)
  (require 'rinari)
  (require 'yaml-mode)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

  (ido-mode t)
  (setq ido-enable-flex-matching t)

  (add-hook 'c-mode-hook 
	    '(lambda ()
	       (linum-mode))))