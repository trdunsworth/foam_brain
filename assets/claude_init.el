;;; init.el --- Emacs initialization file for data science
;;; Commentary:
;; Minimal bootstrap file that loads the literate configuration from myinit.org
;; This approach keeps the main config readable and organized in Org mode

;;; Code:

;; Increase garbage collection threshold during startup for faster loading
(setq gc-cons-threshold most-positive-fixnum)

;; Clean UI - do this early to avoid flash
(setq inhibit-startup-message t)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Package setup - MELPA and GNU ELPA
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)  ; Auto-install packages
(setq use-package-verbose nil)      ; Set to t for debugging

;; Load the literate configuration from myinit.org
(require 'org)
(org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))

;; Custom file setup - keep custom variables separate
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Reset garbage collection threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)) ; 16MB
            (message "Emacs ready in %.2f seconds with %d garbage collections."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

;;; init.el ends here
