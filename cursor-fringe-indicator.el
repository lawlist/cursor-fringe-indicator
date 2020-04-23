;; AUTHOR (of this particular function):  Nikolaj Schumacher -- https://github.com/nschum/fringe-helper.el
(defun +-fringe-helper-decimal (&rest strings)
"Convert STRINGS into a vector usable for `define-fringe-bitmap'.
Each string in STRINGS represents a line of the fringe bitmap.
Periods (.) are background-colored pixel; Xs are foreground-colored. The
fringe bitmap always is aligned to the right. If the fringe has half
width, only the left 4 pixels of an 8 pixel bitmap will be shown.
For example, the following code defines a diagonal line.
\(+-fringe-helper-decimal
\"XX......\"
\"..XX....\"
\"....XX..\"
\"......XX\"\)"
  (unless (cdr strings)
    (setq strings (split-string (car strings) "\n")))
  (apply 'vector
    (mapcar
      (lambda (str)
        (let ((num 0))
          (dolist (c (string-to-list str))
            (setq num (+ (* num 2) (if (eq c ?.) 0 1))))
          num))
      strings)))

(defface +-overlay-arrow-bitmap-face
  '((t (:foreground "blue")))
  "Face for `+-overlay-arrow-bitmap-face'."
  :group '+-mode)

(defun +-set-fringe-cursor ()
"Doc-string"
  (if (not (and (eobp) (bolp)))
     (setq +-left-fringe-overlay-position (copy-marker (line-beginning-position)))
    (setq +-left-fringe-overlay-position  nil)))

(define-fringe-bitmap '+-cursor-left-fringe-bitmap (+-fringe-helper-decimal
  "xx.xx..."
  ".xx.xx.."
  "..xx.xx."
  "...xx.xx"
  "..xx.xx."
  ".xx.xx.."
  "xx.xx...") nil nil 'center)

(set-fringe-bitmap-face '+-cursor-left-fringe-bitmap '+-overlay-arrow-bitmap-face)

;;; `overlay-arrow-bitmap' is a special SYMBOL defined in xdisp.c.

(defvar +-left-fringe-overlay-position nil
  "Doc-string.")

(make-variable-buffer-local '+-left-fringe-overlay-position)

(add-to-list 'overlay-arrow-variable-list '+-left-fringe-overlay-position)

(put '+-left-fringe-overlay-position 'overlay-arrow-bitmap '+-cursor-left-fringe-bitmap)

(add-hook 'post-command-hook '+-set-fringe-cursor 'append 'local)