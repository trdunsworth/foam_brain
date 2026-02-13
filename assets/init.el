;; init.el - minimal loader
    (require 'org)
    (org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))
    (require 'package) 

(setq package-archives '(("melpa" . "https://melpa.org/packages/") 
                         ("gnu" . "https://elpa.gnu.org/packages/"))) 
(package-initialize) 

;; bootstrap `use-package`
(unless (package-installed-p 'use-package) 
  (package-refresh-contents) 
  (package-install 'use-package)) 

(require 'use-package) 

(setq use-package-always-ensure t)  ;; `:ensure t` for all `use-package`

(org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))
;; user-emacs-directory is `~/.emacs.d/`

(setq treesit-language-source-alist
      '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (julia "https://github.com/tree-sitter/tree-sitter-julia")
        (regex "https://github.com/tree-sitter/tree-sitter-regex")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript")))
