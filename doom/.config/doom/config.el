;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Notes/org setup migrated from Obsidian.  Coding stays in nvim.

(setq user-full-name "Daniel Bakalov"
      user-mail-address "dbbakalov@gmail.com")

;; ===========================================================================
;; Appearance — mirror the kitty terminal (Gruvbox Material dark medium,
;; JetBrainsMono NF 16pt, hidden titlebar, 12px padding)
;; ===========================================================================
(setq doom-gruvbox-material-background "medium") ; must be set before the theme loads
(setq doom-theme 'doom-gruvbox-material)
(setq display-line-numbers-type 'relative)

;; kitty: font_size 16.0, modify_font cell_height 110%
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16.0))
(setq-default line-spacing 0.1)

;; kitty: hide_window_decorations + window_padding_width 12.
;; AeroSpace manages windows, so losing the drag handle doesn't matter.
(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(internal-border-width . 12))

;; Dired: hide the drwx/owner/size/date columns — press "(" to toggle them back
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; ===========================================================================
;; Org  — the migrated ~/org "vault"
;; ===========================================================================
(setq org-directory "~/org/")

(after! org
  ;; --- what the agenda scans -------------------------------------------------
  (setq org-agenda-files
        (list "~/school/2026 Summer/"   ; school (synced to Boox) — change when the semester rolls over
              "~/org/"))                 ; personal (local only): inbox, life, media

  ;; --- workflow --------------------------------------------------------------
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)"))
        org-deadline-warning-days 7             ; start warning 1 week out
        org-log-done 'time                      ; stamp completion time
        org-startup-with-inline-images t
        org-image-actual-width '(600))

  (add-hook 'org-mode-hook #'visual-line-mode)  ; soft-wrap prose like Obsidian

  ;; --- capture: school stuff -> synced ~/school, personal -> local ~/org -----
  (setq org-capture-templates
        '(("a" "School assignment (-> school.org, under CSC 230)" entry
           (file+olp "~/school/2026 Summer/school.org" "CSC 230" "Assignments")
           "*** TODO %^{Name}  :%^{Type|exercise|homework|exam|project}:\nDEADLINE: %^{Due}t"
           :empty-lines 1)
          ("i" "Personal inbox" entry
           (file "~/org/inbox.org")
           "* %?\n%U" :empty-lines 1)
          ("t" "Personal todo w/ deadline" entry
           (file "~/org/inbox.org")
           "* TODO %?\nDEADLINE: %^{Deadline}t" :empty-lines 1)))

  ;; --- one custom view; the default agenda (SPC a a) is your main dashboard --
  (setq org-agenda-custom-commands
        '(("o" "Open items by due date"
           ((todo "TODO"
                  ((org-agenda-overriding-header "Open — by due date")
                   (org-agenda-sorting-strategy '(deadline-up)))))))))

;; Prettier org — nudges the plain-text toward Obsidian's rendered feel
(use-package! org-modern
  :after org
  :hook (org-mode . org-modern-mode)
  :hook (org-agenda-finalize . org-modern-agenda))

;; ===========================================================================
;; A few keybinds so your .obsidian.vimrc muscle memory carries over.
;; (SPC leader, gf, C-o/C-i jumplist, / search are already native in Doom.)
;; ===========================================================================
(map! :leader
      :desc "Open file tree"      "e" #'+treemacs/toggle
      :desc "Search in project"   "/" #'+default/search-project
      :desc "Org capture"         "x" #'org-capture
      :desc "Org agenda"          "a" #'org-agenda)
