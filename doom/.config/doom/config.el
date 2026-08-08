(setq user-full-name "Daniel Bakalov"
      user-mail-address "dbbakalov@gmail.com")

(setq doom-theme 'kanagawa-dragon)
(setq display-line-numbers-type 'relative)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16.0))

(custom-set-faces!
  '(org-level-1 :height 1.0)
  '(org-level-2 :height 1.0)
  '(org-level-3 :height 1.0))
(setq-default line-spacing 0.1)

(load! "+theme")

(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(internal-border-width . 12))

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(setq org-directory "~/org/")

(after! org
  (setq org-agenda-files
        (list "~/school/2026 Fall/"
              "~/org/"))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "STRT(s)" "|" "DONE(d)" "KILL(k)"))
        org-blank-before-new-entry '((heading . nil)
                                     (plain-list-item . nil))
        org-deadline-warning-days 7
        org-log-done 'time
        org-startup-with-inline-images t
        org-image-actual-width '(600)
        org-agenda-timegrid-use-ampm t)

  (add-hook 'org-mode-hook #'visual-line-mode)

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
        '(("i" "Todo (-> todo.org)" entry
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
          ("ef" "FPL deadline" entry
           (file+headline "~/org/calendar.org" "FPL")
           "* GW%^{Gameweek} Deadline\n%^T")
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

  (setq org-agenda-custom-commands
        '(("o" "Open items by due date"
           ((todo "TODO"
                  ((org-agenda-overriding-header "Open — by due date")
                   (org-agenda-sorting-strategy '(deadline-up)))))))))

(use-package! org-modern
  :after org
  :hook (org-mode . org-modern-mode)
  :hook (org-agenda-finalize . org-modern-agenda)
  :config
  (setq org-modern-fold-stars
        '(("▶" . "▼") ("▷" . "▽") ("▸" . "▾") ("▹" . "▿") ("▶" . "▼"))))

(setq ledger-binary-path "hledger"
      ledger-mode-should-check-version nil
      ledger-report-links-in-register nil)

(setq-default ledger-master-file "~/org/finances.org")

(setq ledger-reports
      '(("balance sheet" "hledger -f ~/org/finances.org bs --market")
        ("income statement (monthly)" "hledger -f ~/org/finances.org is --monthly")
        ("register" "hledger -f ~/org/finances.org register")
        ("account register" "hledger -f ~/org/finances.org register %(account)")))

(map! :leader
      :desc "Open file tree"      "e" #'+treemacs/toggle
      :desc "Search in project"   "/" #'+default/search-project
      :desc "Org capture"         "x" #'org-capture
      :desc "Org agenda"          "a" #'org-agenda)
