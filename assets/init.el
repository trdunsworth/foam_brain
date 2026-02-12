;; init.el - minimal loader
    (require 'org)
    (org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))
