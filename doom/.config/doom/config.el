;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Notes/org setup migrated from Obsidian.  Coding stays in nvim.

(setq user-full-name "Daniel Bakalov"
      user-mail-address "dbbakalov@gmail.com")

;; ===========================================================================
;; Appearance — mirror the kitty terminal (Kanagawa Dragon,
;; JetBrainsMono NF 16pt, hidden titlebar, 12px padding)
;; ===========================================================================
(setq doom-theme 'kanagawa-dragon)
(setq display-line-numbers-type 'relative)

;; kitty: font_size 16.0, modify_font cell_height 110%
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16.0))

;; Some themes scale org headings (1.1x–1.4x). Keep the heading colors but
;; pin them to normal text size.
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
  ;; Target for the finance capture: point just before #+end_src of this
  ;; month's ledger block in finances.org, creating the * YEAR / ** MONTH
  ;; headings and block (in front of * Prices) when the month rolls over.
  (defun my/finances-capture-target ()
    (let ((year (format-time-string "%Y"))
          (month (format-time-string "%B")))
      (goto-char (point-min))
      (if (re-search-forward (format "^\\* %s[ \t]*$" year) nil t)
          (org-back-to-heading t)
        (if (re-search-forward "^\\* Prices[ \t]*$" nil t)
            (goto-char (match-beginning 0))
          (goto-char (point-max))
          (unless (bolp) (insert "\n")))
        (insert (format "* %s\n" year))
        (forward-line -1))
      (let ((year-end (save-excursion (org-end-of-subtree t t) (point))))
        (if (re-search-forward (format "^\\*\\* %s[ \t]*$" month) year-end t)
            (let ((month-end (save-excursion (org-end-of-subtree t t) (point))))
              (if (re-search-forward "^[ \t]*#\\+end_src" month-end t)
                  (goto-char (match-beginning 0))
                (goto-char month-end)
                (insert "#+begin_src ledger\n#+end_src\n")
                (forward-line -1)))
          (goto-char year-end)
          (insert (format "** %s\n#+begin_src ledger\n#+end_src\n" month))
          (forward-line -1)))))

  ;; The finance template can't align amounts itself (prompts expand after the
  ;; template text), so right-align them to column 48 as the capture files.
  (defun my/finances-align-posting ()
    (when (equal (org-capture-get :key) "f")
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward
                "^\\([ \t]+[A-Za-z][A-Za-z:]*\\)[ \t]+\\(\\$[0-9][0-9.,]*\\)[ \t]*$" nil t)
          (replace-match
           (concat (match-string 1)
                   (make-string (max 2 (- 48 (length (match-string 1))
                                          (length (match-string 2))))
                                ?\s)
                   (match-string 2))
           t t)))))
  (add-hook 'org-capture-before-finalize-hook #'my/finances-align-posting)

  (setq org-capture-templates
        '(("a" "School assignment (-> school.org, under CSC 230)" entry
           (file+olp "~/school/2026 Summer/school.org" "CSC 230" "Assignments")
           "*** TODO %^{Name}  :%^{Type|exercise|homework|exam|project}:\nDEADLINE: %^{Due}t")
          ("i" "Todo (-> todo.org)" entry
           (file "~/org/todo.org")
           "* TODO %?" :prepend t)
          ("t" "Todo w/ deadline (-> todo.org)" entry
           (file "~/org/todo.org")
           "* TODO %?\nDEADLINE: %^{Deadline}t" :prepend t)
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
           :empty-lines 1)
          ("f" "Finance transaction (-> finances.org, this month)" plain
           (file+function "~/org/finances.org" my/finances-capture-target)
           "%^{Date|%<%Y-%m-%d>} %^{Payee | description}
    %^{Account|Expenses:Food|Expenses:Transport|Expenses:Housing|Expenses:Utilities|Expenses:Subscriptions|Expenses:Health|Expenses:Shopping|Expenses:Fun|Expenses:Misc|Assets:Checking|Assets:Savings|Assets:Cash|Assets:VTI|Income:Allowance|Income:Dividends}    $%^{Amount}
    %^{From account|Liabilities:Credit|Assets:Checking|Assets:Cash|Assets:Savings}
"
           :empty-lines-before 1 :immediate-finish t)))

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

;; ledger-report needs a journal file; without this it falls back to
;; buffer-file-name, which is nil in C-c ' src-edit buffers and errors.
;; Buffer-local variable, so setq-default.
(setq-default ledger-master-file "~/org/finances.org")

;; M-x ledger-report. Paths are fixed so reports also work from the org file.
(setq ledger-reports
      '(("balance sheet" "hledger -f ~/org/finances.org bs --market")
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
