(defun nml-load-scala ()
  (require 'scala-mode-auto))

(defun nml-load-clojure ()
  (autoload 'clojure-mode "clojure-mode" "A major mode for Clojure" t)
  (add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))
   (defun lisp-enable-paredit-hook () (paredit-mode 1))
   (add-hook 'clojure-mode-hook 'lisp-enable-paredit-hook))

(defun nml-load-haskell ()
  (load "haskell-mode/haskell-site-file")
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  (set-variable 'haskell-program-name "ghci -fglasgow-exts"))

(defun nml-load-slime ()
  (require 'slime)
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (slime-setup))

(defun nml-load-ruby ()
  (require 'ruby-mode)
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
  (load "nxhtml/autostart.el"))

(defun nml-load-ioke ()
  (require 'ioke-mode))

(defun nml-load-io ()
  (add-to-list 'auto-mode-alist '("\\.io$" . io-mode)))

(defun nml-load-yasnippet ()
  (require 'yasnippet)
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
  ;;python
  (add-hook 'python-mode-hook
	    '(lambda ()
	       (outline-minor-mode)
	       (hide-other)))
  ;;lisp
  (global-set-key "\M-?" 'lisp-complete-symbol)

  ;;yasnippet
  (add-hook 'javascript-mode
	    '(lambda ()
	       (yas/minor-mode))))