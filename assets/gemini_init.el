;; init.el --- Robust Data Science Bootstrap
(setq gc-cons-threshold (* 50 1024 1024)) ;; Increase garbage collection limit for startup

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Load the Literate Config (only once) [cite: 202]
(org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))

;; Reset GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1024 1024))))
