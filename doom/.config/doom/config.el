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

;; The gruvbox-material theme scales org headings (1.4x/1.2x/1.1x). Keep the
;; heading colors but pin them to normal text size.
(custom-set-faces!
  '(org-level-1 :height 1.0)
  '(org-level-2 :height 1.0)
  '(org-level-3 :height 1.0))
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
  ;; --- habits: consistency graph in the agenda for habits.org entries --------
  (add-to-list 'org-modules 'org-habit)
  (require 'org-habit)
  (setq org-extend-today-until 3    ; the day rolls over at 3am, not midnight
        org-use-effective-time t)   ; late-night DONEs log against the day just ending

  ;; --- what the agenda scans -------------------------------------------------
  (setq org-agenda-files
        (list "~/school/2026 Summer/"   ; school (synced to Boox) — change when the semester rolls over
              "~/org/"))                 ; personal (local only): todo, calendar, life, media

  ;; --- workflow --------------------------------------------------------------
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STRT(s)" "|" "DONE(d)" "KILL(k)"))
        org-blank-before-new-entry '((heading . nil)          ; never insert blank
                                     (plain-list-item . nil)) ; lines around new entries
        org-deadline-warning-days 7             ; start warning 1 week out
        org-log-done 'time                      ; stamp completion time
        org-startup-with-inline-images t
        org-image-actual-width '(600)
        org-agenda-timegrid-use-ampm t)         ; 12-hour AM/PM in the agenda, not 24h

  (add-hook 'org-mode-hook #'visual-line-mode)  ; soft-wrap prose like Obsidian

  ;; --- capture: school stuff -> synced ~/school, personal -> local ~/org -----
  (setq org-capture-templates
        '(("a" "School assignment (-> school.org, under CSC 230)" entry
           (file+olp "~/school/2026 Summer/school.org" "CSC 230" "Assignments")
           "*** TODO %^{Name}  :%^{Type|exercise|homework|exam|project}:\nDEADLINE: %^{Due}t")
          ("i" "Todo (-> todo.org)" entry
           (file "~/org/todo.org")
           "* TODO %?")
          ("t" "Todo w/ deadline (-> todo.org)" entry
           (file "~/org/todo.org")
           "* TODO %?\nDEADLINE: %^{Deadline}t")
          ("e" "Event (-> calendar.org)")
          ("ea" "Appointment" entry
           (file+headline "~/org/calendar.org" "Appointments")
           "* %^{Event}\n%^T")
          ("em" "Meeting" entry
           (file+headline "~/org/calendar.org" "Meetings")
           "* %^{Event}\n%^T")
          ("es" "Soccer game" entry
           (file+headline "~/org/calendar.org" "Soccer games")
           "* %^{Event}\n%^T")
          ("ev" "Movie" entry
           (file+headline "~/org/calendar.org" "Movies")
           "* %^{Event}\n%^T")
          ("ee" "Misc event" entry
           (file+headline "~/org/calendar.org" "Misc")
           "* %^{Event}\n%^T")
          ("r" "Daily reflection (-> reflections.org, under today)" entry
           (file+olp+datetree "~/org/reflections.org")
           "* Reflection
** What's still on my mind?
%?
** What did I do today?

** What went well or didn't go well?

** What made me feel anxious or stressed (if anything)?

** What would make tomorrow a good day?
"
           :empty-lines 1)))

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
  :hook (org-agenda-finalize . org-modern-agenda)
  :config
  ;; Default level-3 pair is ⯈/⯆ (U+2BC8/U+2BC6), which JetBrainsMono NF
  ;; lacks — it rendered as hex tofu boxes. One (folded . expanded) pair per
  ;; heading level, all from glyphs the font actually has.
  (setq org-modern-fold-stars
        '(("▶" . "▼") ("▷" . "▽") ("▸" . "▾") ("▹" . "▿") ("▶" . "▼"))))

;; ===========================================================================
;; Finances — hledger journal in ~/org/finances.org (org outline + ledger
;; src blocks; hledger reads it directly since *, #, ; lines are comments)
;; ===========================================================================
;; ledger-mode drives hledger instead of ledger (hledger.org editor setup).
;; C-c ' on a src block edits it with ledger-mode completion/alignment.
(setq ledger-binary-path "hledger"
      ledger-mode-should-check-version nil
      ledger-report-links-in-register nil)

;; M-x ledger-report. Paths are fixed so reports also work from the org file.
(setq ledger-reports
      '(("balance sheet" "hledger -f ~/org/finances.org bs")
        ("income statement (monthly)" "hledger -f ~/org/finances.org is --monthly")
        ("register" "hledger -f ~/org/finances.org register")
        ("account register" "hledger -f ~/org/finances.org register %(account)")))

;; ===========================================================================
;; A few keybinds so your .obsidian.vimrc muscle memory carries over.
;; (SPC leader, gf, C-o/C-i jumplist, / search are already native in Doom.)
;; ===========================================================================
(map! :leader
      :desc "Open file tree"      "e" #'+treemacs/toggle
      :desc "Search in project"   "/" #'+default/search-project
      :desc "Org capture"         "x" #'org-capture
      :desc "Org agenda"          "a" #'org-agenda)
