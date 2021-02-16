;; for reference:
;;
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; lol:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org files:

(require 'password-store)
(load "~/conf/doom/org-conf")

(setq gc-cons-threshold 20000000)
;; (print mode-line-misc-info)
;; (setq  mode-line-misc-info (assq-delete-all         'eglot--managed-mode-hook mode-line-misc-info))
;; global-mode-string
;; (setq my/session-name "lol")
;; (add-to-list 'global-mode-string 'my/session-name)
;; (setq mode-line-misc-info
;;       (list `(lol ,(concat "lol " (daemonp)))))
(setq server-name (daemonp))
(when (string= "DANCE_COMMANDER" server-name)
  (load "~/conf/doom/yolobolo.el")
  (use-package! org-protocol))

(load "~/conf/doom/fancy.el")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; global config:


;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(use-package! evil-escape
  :init
  (setq evil-escape-delay 0.3
        evil-escape-key-sequence "jj"
        ;; evil-cross-lines t
        ))
(setq company-minimum-prefix-length 2
      company-idle-delay 0.0
      )
(setq completion-styles
      '(basic partial-completion emacs22))

;; (setq company-fuzzy-sorting-backend 'flx
;;         company-fuzzy-prefix-on-top nil
;;         ;; company-fuzzy-history-backends '(company-yasnippet)
;;         ;; company-fuzzy-trigger-symbols '("." "->" "<" "\"" "'")
;;         )
;; (use-package! company-fuzzy
;;   :init
;;   (setq company-fuzzy-sorting-backend 'flx
;;         company-fuzzy-prefix-on-top nil
;;         ;; company-fuzzy-history-backends '(company-yasnippet)
;;         ;; company-fuzzy-trigger-symbols '("." "->" "<" "\"" "'")
;;         )
;;   (with-eval-after-load 'company (global-company-fuzzy-mode t)))
;; (after! company
;;   (global-company-fuzzy-mode t))
;; (global-company-fuzzy-mode t)
;; (print completion-styles)

(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'electric-indent-mode)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; (global-spell-fu-mode 0)
(setq ispell-program-name "/usr/bin/hunspell")
(setq ispell-dictionary "en_GB,fr_FR")
(add-to-list 'ispell-local-dictionary-alist '("en_GB,fr_FR" "[[:alpha:]]" "[^[:alpha:]]" "[0-9']" t
                                              ("-d" "en_GB,fr_FR")
                                              nil utf-8))


(use-package flyspell
  :init
  (add-hook 'org-mode-hook
            (lambda () (flyspell-mode 1))))



(setq evil-search-wrap nil)
;;
(setq projectile-project-search-path '("~/conf" "~/conf/private" "/work/" "/work/besport" "/work/ocaml"))

(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "William"
      user-mail-address "john@doe.com")


;; nil numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;; (setq scroll-margin 0)
(setq evil-snipe-scope 'whole-visible)

(setq avy-keys '(?u ?h ?e ?t ?. ?c ?i ?d ?k ?m ?j ?w ?o ?n ?p ?g))
(setq avy-all-windows t)

;; parens & clojure:

(use-package! eval-sexp-fu
  ;:defer t
  ;:hook ((emacs-lisp-mode . eval-sexp-fu-flash-mode))
  )
(use-package! cider-eval-sexp-fu)

;; elisp mode wants most of this too:
(after! clojure-mode
  (add-hook 'clojure-mode-hook #'eval-sexp-fu-flash-mode)
  (add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode) ;; difficult to use with trace-form cljsrn fn tracing
  (add-hook 'clojure-mode-hook #'electric-indent-mode)
  (setq clojure-indent-style 'align-arguments)
  (setq clojure-align-forms-automatically t))

;; (setq evil-cleverparens-use-additional-movement-keys nil)
(add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
                                        ;(add-hook 'emacs-lisp-mode-hook #'aggressive-indent)
                                        ;(evil-cleverparens-mode)
;; (after! elisp-mode)
;;
;; TODO: test this: cleverparens
;; (defun my-after-evil ()
;;   (global-evil-surround-mode)
;;   (eyebrowse-mode)
;;   (eyebrowse-setup-opinionated-keys)
;;   (require 'evil-cleverparens-text-objects))
;; (add-hook 'evil-mode-hook 'my-after-evil)

(defun my/reset-paragraph-variables ()
  (kill-local-variable 'paragraph-start)
  (kill-local-variable 'paragraph-separate))
(add-hook 'org-mode-hook 'my/reset-paragraph-variables)


(map! :map evil-cleverparens-mode-map
      :nvm "{" #'evil-backward-paragraph
      :nvm "}" #'evil-forward-paragraph
      :nvm ")" #'evil-cp-next-closing
      :nvm "(" #'sp-backward-up-sexp
      :nvm "é" #'evil-cp-previous-opening ; FIXME put this in global map?
      :nvm "&" #'evil-cp-next-opening
      :nvm "M-r" #'paredit-raise-sexp
      :nvm "M-t"  #'sp-transpose-sexp
      :nvm "M-T"  (lambda() (interactive) (sp-transpose-sexp -1))
      :nvm "M-g p" #'evil-cp-wrap-next-round
      :nvm "M-g P" #'evil-cp-wrap-previous-round
      :nvm "M-g c" #'evil-cp-wrap-next-curly
      :nvm "M-g C" #'evil-cp-wrap-previous-curly
      :nvm "M-g s" #'evil-cp-wrap-next-square
      :nvm "M-g S" #'evil-cp-wrap-previous-square
      ;; :nvm "s"  #'evil-aavy-goto-char-2 use: gss
      :nvm "s"  #'evil-snipe-s
      :nvm "S"  #'evil-snipe-S)

(map! :map evil-cleverparens-mode-map
      :localleader
      :nvm "r"   #'paredit-raise-sexp
      :nvm "R"   #'evil-cp-raise-form
      :nvm "t"   #'sp-transpose-sexp
      :nvm "T"   (lambda() (interactive) (sp-transpose-sexp -1))
      :nvm "M-T" (lambda() (interactive) (sp-transpose-sexp -1))
      :nvm "g p" #'evil-cp-wrap-next-round
      :nvm "g P" #'evil-cp-wrap-previous-round
      :nvm "g c" #'evil-cp-wrap-next-curly
      :nvm "g C" #'evil-cp-wrap-previous-curly
      :nvm "g s" #'evil-cp-wrap-next-square
      :nvm "g S" #'evil-cp-wrap-previous-square
      )

(map! :map clojure-mode-map
      :localleader
      ;:nvm "RET" #'cider-eval-last-sexp
      :nvm "RET" #'cider-eval-list-at-point
      )

;; (map! :map clojure-mode-map
;;       :nvm "s"  #'evil-avy-goto-char-2
;;       )

(map! :map emacs-lisp-mode-map
      :localleader
      :nvm "RET" #'eval-defun)

;; keyboard macros, for reference: https://www.emacswiki.org/emacs/KeyboardMacrosTricks
;; kmacro-name-last-macro
;; insert-kbd-macro
(map! :localleader
      :map org-mode-map
      ;; send title (current line)
      :nvm "D"    #'org-decrypt-entries
      :nvm "ga"   (fset 'archive-send-jt
                        (kmacro-lambda-form [return return ?y ?y ?  ?j ?t ?G ?p ?c ?e ?* ?* ?* ?j ?j return ?t ?d ?o ?\C-c ?. return ?j ?j ?\C-w ?\C-w] 0 "%d"))
      ;; send tree (this sometimes does BS on small lists)
      :nvm "gAr"  (fset 'r-archive-send-jt
                        (kmacro-lambda-form [return return ?y ?a ?r ?  ?j ?t ?G ?p ?c ?e ?* ?* ?* ?j ?j return ?t ?d ?o ?\C-c ?. return ?j ?j ?\C-w ?\C-w] 0 "%d"))
      ;; send tree (this sometimes does BS on small lists) without marking current as done
      :nvm "gAs"  (fset 'r-send-jt
                        (kmacro-lambda-form [?y ?a ?r ?  ?j ?t ?G ?p ?c ?e ?* ?* ?* ?j ?j return ?t ?d ?o ?\C-c ?. return ?j ?j ?\C-w ?\C-w] 0 "%d"))
      ;; make checkbox of this
      :nvm "gt"   (fset 'mk-todo
                        (kmacro-lambda-form [return ?* return ?t ?t ?< ?< ?$] 0 "%d"))
      ;; make todo of this
      :nvm "gT"   (fset 'mk-todo
                        (kmacro-lambda-form [return ?* return ?t ?T ?< ?< ?$] 0 "%d"))
      ;; clock resolve keep
      :nm  "ck"       (fset 'clock-resolve
                            (kmacro-lambda-form [return ?c ?r ?K] 0 "%d"))
      :nvm "RET" #'+org/dwim-at-point
      ;; tables
      :nvm "b>" #'org-table-move-column-right
      :nvm "b<" #'org-table-move-column-left
      :nvm "h" (lambda()
                 (interactive)
                 (org-toggle-heading)
                 (outline-promote))
      ;; dates:
      :desc "inactive timestamp"            :nvm "dn" #'my/insert-inactive-timestamp
      ;; subtree
      :desc "refile copy"                   :nvm "sc" #'org-refile-copy
      )

(map! :map org-mode-map
      ;;:i "RET" #'org-return-and-maybe-indent
      :v   "O"        #'evil-org-open-links
      :nvm "zD"       #'org-decrypt-entries
      :nvm "zq"       #'(lambda() (interactive) (org-show-branches-buffer))
      :nvm "("        #'org-previous-visible-heading
      :nvm ")"        #'org-next-visible-heading
      :nvm "{"        #'evil-backward-paragraph
      :nvm "}"        #'evil-forward-paragraph
      :nvm "$"        #'evil-end-of-line
      :nv   "<left>"  #'org-promote-subtree
      :nv   "<down>"  #'org-move-subtree-down
      :nv   "<up>"    #'org-move-subtree-up
      :nv   "<right>" #'org-demote-subtree)

(defun my/journal-new-todo ()
  (interactive)
  (org-journal-new-scheduled-entry nil (format-time-string "%Y-%m-%d %a" (current-time)))
  (evil-append 0))

(map! :map org-journal-mode-map
      :localleader
      :nvm "n" #'my/journal-new-todo ;; FIXME trigger capture
      :nvm "N" #'org-journal-new-date-entry
      :nvm "r" #'org-journal-new-scheduled-entry
      :nvm "j" #'org-journal-next-entry
      :nvm "k" #'org-journal-previous-entry
      )

;; ocaml

(defconst opam-lisp-dir
  (let ((opam-share
         (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
    (when (and opam-share (file-directory-p opam-share))
      (expand-file-name "emacs/site-lisp/" opam-share))))
   ;; fixme: compare with this:
   ;; Add opam emacs directory to your load-path by appending this to your .emacs:
   ;;   (let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
   ;;    (when (and opam-share (file-directory-p opam-share))
   ;;     ;; Register Merlin
   ;;     (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
   ;;     (autoload 'merlin-mode "merlin" nil t nil)
   ;;     ;; Automatically start it in OCaml buffers
   ;;     (add-hook 'tuareg-mode-hook 'merlin-mode t)
   ;;     (add-hook 'caml-mode-hook 'merlin-mode t)
   ;;     ;; Use opam switch to lookup ocamlmerlin binary
   ;;     (setq merlin-command 'opam)))


;; (print opam-lisp-dir)
(add-to-list 'load-path opam-lisp-dir)
;; (load opam-lisp-dir )
;;(load (concat opam-lisp-dir "tuareg-site-file"))
;(require 'dune)
(require 'ocamlformat)

(setq merlin-completion-dwim nil)

;; FIXME bikeshedding? 72? final-newline? seems ugly.
(setq-default fill-column 80
              indent-tabs-mode nil
              mode-line-format (remove '(vc-mode vc-mode) mode-line-format)
              require-final-newline t
              scroll-down-aggressively 0
              scroll-up-aggressively 0)
(setq fci-rule-color "#073642")

(setq comint-prompt-read-only t ; comint -> repl
      comment-multi-line t
      compilation-scroll-output 'first-error
      compilation-context-lines 0
      disabled-command-function nil
      merlin-command 'opam
      merlin-completion-with-doc t
      sql-product 'postgres
      track-eol t
      tuareg-interactive-read-only-input t
      view-read-only t
      vc-follow-symlinks t)

(mapc (lambda (ext) (add-to-list 'completion-ignored-extensions ext))
      '(".bc" ".byte" ".exe" ".native"))

(mapc (lambda (ext) (add-to-list 'auto-mode-alist ext))
      '(("dune-project\\'" . dune-mode)
        ("dune-workspace\\'" . dune-mode)
        ("README\\'" . text-mode)
        ("\\.dockerignore\\'" . conf-unix-mode)
        ("\\.gitignore\\'" . conf-unix-mode)
        ("\\.merlin\\'" . conf-space-mode)
        ("\\.ocamlinit\\'" . tuareg-mode)
        ("\\.top\\'" . tuareg-mode)))

;; Hack to open files like Makefile.local with the right mode.
(add-to-list 'auto-mode-alist '("\\.[^\\.].*\\'" nil t) t)

(defun fuck-me/init-tuareg-map ()
  (map! :localleader
      :map tuareg-mode-map
      "o"   #'merlin-pop-stack
      "RET" #'tuareg-eval-phrase
      "b"   #'tuareg-eval-buffer
      "TAB" #'tuareg-complete
      "K"   #'tuareg-kill-ocaml
      "a"   #'ff-get-other-file
      ))
(fuck-me/init-tuareg-map)

(map! :map tuareg-mode-map
      :i "TAB" #'company-indent-or-complete-common)
;; for your eval convenience  (remove-hook 'tuareg-mode #'ocamlformat-before-save)
(add-hook 'tuareg-mode-hook #'(lambda ()
                                (setq mode-name "🐫")
                                ;; FIXME( integrate this after trying them out.
                                (define-key tuareg-mode-map (kbd "C-M-<tab>") #'ocamlformat)
                                ;; FIXME)
                                (add-hook 'before-save-hook #'ocamlformat-before-save)
                                (setq ff-other-file-alist '(("\\.mli\\'" (".ml")) ;; mll
                                                            ("\\.ml\\'" (".mli"))
                                                            ("\\.eliomi\\'" (".eliom"))
                                                            ("\\.eliom\\'" (".eliomi"))))
                                (setq-local comment-style 'indent)
                                (setq-local tuareg-interactive-program
                                            (concat tuareg-interactive-program " -nopromptcont"))
                                (let ((ext (file-name-extension buffer-file-name)))
                                  (when (string-equal ext "eliom")
                                    (setq-local ocamlformat-file-kind 'implementation))
                                  (when (string-equal ext "eliomi")
                                    (setq-local ocamlformat-file-kind 'interface)))
                                (add-hook 'before-save-hook 'ocamlformat-before-save t t)
                                ;; (merlin-mode)
                                ))
;;(add-hook 'tuareg-mode-hook 'lsp-deferred)

;; (add-hook 'prog-mode-hook 'lsp-deferred)
;; (lsp-register-client
;;    (make-lsp-client
;;     :new-connection (lsp-stdio-connection
;;                      '("opam" "exec" "--" "ocamllsp"))
;;     :major-modes '(caml-mode tuareg-mode)
;;     :server-id 'ocaml-lsp))
;; (defcustom lsp-ocaml-lsp-server-command
;;   '("ocamllsp")
;;   "Command to start ocaml-language-server."
;;   :group 'lsp-ocaml
;;   :type '(choice
;;           (string :tag "Single string value")
;;           (repeat :tag "List of string values"
;;                   string)))
;; (lsp-register-client
;;  (make-lsp-client
;;   :new-connection
;;   (lsp-stdio-connection (lambda () lsp-ocaml-lsp-server-command))
;;   :major-modes '(caml-mode tuareg-mode)
;;   :priority 0
;;   :server-id 'ocaml-lsp-server))

(add-hook 'css-mode-hook 'prettier-js-mode)

(setq prettier-js-command "/home/wjc/.nvm/versions/node/v10.23.1/bin/prettier")

(with-eval-after-load "whitespace"
  (setq whitespace-action '(auto-cleanup)))

;; global:
(map! ;; :nv "s"  #'evil-avy-goto-char-2
      ;; :nv "C->" #'transpose-sexps
 ;; :nv "C-<" #'(lambda() (interactive) (transpose-sexps -1))
 :n   "-d"          #'delete-trailing-whitespace
 :n   "C-S-<left>"  #'winner-undo
 :n   "C-S-<right>" #'winner-redo
 :nv  "C-t"         #'transpose-words
 :nv  "g>"          #'transpose-words
 :nv  "g<"          #'(lambda() (interactive) (transpose-words -1))
 :nv  "C-*"         #'evil-multiedit-match-symbol-and-prev
 :nv  "C-8"         #'evil-multiedit-match-symbol-and-next
 :nvm "é"           #'evil-cp-previous-opening ; FIXME put this in global map?
 :nvm "&"           #'evil-cp-next-opening
 :nvm "gzn"           #'evil-mc-make-and-goto-next-match
 :nvm "gzN"           #'evil-mc-skip-and-goto-next-match
 ;; breadcrumb
 :nvm "S-SPC"       #'bc-set
 :nvm  "C-j"        #'bc-next
 :nvm  "C-k"        #'bc-previous
 :nvm  "C-S-j"        #'bc-local-next
 :nvm  "C-S-k"        #'bc-local-previous
 ;; ignored or overwritten, doom rape.
 ;:i   "TAB"         #'company-indent-or-complete-common
 ;:i   [tab]         #'company-indent-or-complete-common
 :i   "C-b"         #'yas-expand
 :i   "C-v"         #'evil-paste-before
 :i   "C-V"         #'evil-paste-before)

;; global
(map! :leader
      :nvm "SPC"  #'ivy-switch-buffer
      :nvm "'"    #'+ivy/projectile-find-file
      :nvm "ng"   #'counsel-org-goto-all ;; nG in split buffer?

      :desc "today"              :nvm "jt" #'(lambda() (interactive) (my/journal-open-today))
      :desc "today other window" :nvm "jT" #'(lambda() (interactive) (my/journal-open-today t))

      :nvm "jn" #'my/journal-new-todo ;; FIXME remove/or call capture instead?
      :nvm "jN" #'org-journal-new-entry
      :nvm "jr" #'org-journal-new-scheduled-entry

      :desc "breadcrumb prev" :nvm  "<" #'bc-previous
      :desc "breadcrumb next" :nvm  ">" #'bc-next
      :desc "breadcrumb prev" :nvm  "l<" #'bc-local-previous
      :desc "breadcrumb next" :nvm  "l>" #'bc-local-next

      :desc "breadcrumb list" :nvm  "jl" #'bc-list
      :desc "breadcrumb goto curr" :nvm  "jc" #'bc-goto-current

      :desc "follow" :nvm "taf" #'org-agenda-follow-mode

      :desc "Open Calendar"                 :nvm "dC" #'=calendar
      :desc "Sync calendar"                 :nvm "dS" #'org-gcal-sync
      :desc "Delete from calendar"          :nvm "dX" #'org-gcal-delete-at-point
      :desc "Post to calendar"              :nvm "dP" #'org-gcal-post-at-point

      :desc "inactive timestamp"            :nvm "dn" #'my/insert-inactive-timestamp

      :desc "password-store"                :nvm "P"  #'ivy-pass
      :desc "Switch to buffer"              :nvm "rb" #'org-roam-switch-to-buffer
      :desc "Org Roam Capture"              :nvm "rc" #'org-roam-capture
      :desc "Find file"                     :nvm "rf" #'org-roam-find-file
      :desc "Show graph"                    :nvm "rg" #'org-roam-graph
      :desc "Insert"                        :nvm "ri" #'org-roam-insert
      :desc "Insert (skipping org-capture)" :nvm "rI" #'org-roam-insert-immediate
      :desc "Org Roam"                      :nvm "rr" #'org-roam
      :desc "Roam tag"                      :nvm "rq" #'org-roam-tag-add
      :desc "Arbitrary date"                :nvm "rdd" #'org-roam-dailies-date
      :desc "Today"                         :nvm "rdt" #'org-roam-dailies-today
      :desc "Tomorrow"                      :nvm "rdm" #'org-roam-dailies-tomorrow
      :desc "Yesterday"                     :nvm "rdy" #'org-roam-dailies-yesterday
      )

(map! :map org-agenda-mode-map ;; FIXME this is completely ignored :/
      :nvm "C-n" (lambda () (interactive) (scroll-up 4))
      :nvm "C-p" (lambda () (interactive) (scroll-down 4))
      :nvm "j" #'org-agenda-next-line
      :nvm "k" #'org-agenda-previous-line)

;; dired
(map! :localleader
      :map dired-mode-map
      :nvm "RET" #'dired-find-file)


;; helper:
(defun my/keymap-symbol ()
  "Return the symbol to which KEYMAP is bound, or nil if no such symbol exists."
  (interactive)
  (let ((keymap (current-local-map)))
    (print (catch 'gotit
             (mapatoms (lambda (sym)
                   (and (boundp sym)
                        (eq (symbol-value sym) keymap)
                        (not (eq sym 'keymap))
                        (throw 'gotit sym))))))))

(defun fuck-me/init ()
  "doom init is fucking with me. Work around password-store & fonts init."
  (interactive)
  (fuck-me/init-tuareg-map)
  (fuck-me/init-font-symbols)
  (fuck-me/init-cal)
  (fuck-me/init-capture)
  (fuck-me/init-faces))


;; Shell mode;
;
;; (setq indent-tabs-mode nil)
;; bullshit none of this works:
(setq-default sh-indentation 2)
(setq-default sh-offset 2)
(setq sh-indent 2)
(setq sh-basic-offset 2)
(setq sh-offset 2)

(use-package! highlight-indent-guides)

(setq highlight-indent-guides-method 'fill)
(setq highlight-indent-guides-auto-enabled nil)

;; (set-face-background 'highlight-indent-guides-odd-face "#073642")
;; (set-face-background 'highlight-indent-guides-even-face "#03282F")

(set-face-background 'highlight-indent-guides-odd-face "#073642")
(set-face-background 'highlight-indent-guides-even-face "#002b36")

;;(set-face-foreground 'highlight-indent-guides-character-face "dimgray")


;; (print yas-snippet-dirs)
;; (print doom-snippets-dir)
;; (print +file-templates-dir)
