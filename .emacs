(add-to-list 'load-path "~/.emacs.d/vendor/git-mode/")
(require 'git)

(add-to-list 'load-path "~/.emacs.d/vendor/gitsum/")
(require 'gitsum)

(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode/")
(require 'coffee-mode)

(defun coffee-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2)

  ;; Compile '.coffee' files on every save
  (add-hook 'after-save-hook
      '(lambda ()
         (when (string-match "\.coffee$" (buffer-name))
          (coffee-compile-file)))))

(add-hook 'coffee-mode-hook '(lambda () (coffee-custom)))

;; tmux-like buffer manipulation key bindings 
(global-set-key (kbd "C-x n") 'next-buffer)
(global-set-key (kbd "C-x p") 'previous-buffer)
(global-set-key (kbd "C-o") 'next-buffer)
;(global-set-key (kbd "C-O") 'previous-buffer)


