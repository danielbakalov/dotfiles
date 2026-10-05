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
  ;; The agenda is split into two worlds, each with its own dispatcher key.
  ;; Each of those custom commands rebinds org-agenda-files to just its
  ;; own slice, which is what keeps them from bleeding into each other:
  ;;   SPC a t  general todos  — my/general-agenda-files
  ;;   SPC a s  school work    — my/school-agenda-files
  ;; The global views (SPC a a, SPC a o) see both together.
  ;; One file under ~/org/ is excluded from org-agenda-files entirely
  ;; (see my/agenda-excluded-files):
  ;;   study-log.org    — written by the `study` CLI; pure clock data with no
  ;;     TODOs, so it has nothing to contribute to an agenda.
  ;; Directories are listed explicitly and scanned one level deep — a new
  ;; subdirectory of ~/org/ has to be added here to reach the agenda.
  (defconst my/school-agenda-files '("~/school/2026 Fall/")
    "Org files for the current semester.
A directory is scanned one level deep by the agenda, so course
subdirectories are ignored — only school.org itself is read.
Bump the semester here each term.")

  (defconst my/agenda-excluded-files '("study-log.org")
    "Basenames under ~/org/ that stay out of the agenda entirely.")

  (defconst my/general-agenda-files
    (seq-remove (lambda (f)
                  (seq-some (lambda (name) (string-suffix-p name f))
                            my/agenda-excluded-files))
                (seq-mapcat (lambda (dir) (directory-files dir t "\\.org\\'"))
                            '("~/org/")))
    "Life outside school: everything under ~/org/ but the excluded files.
Expanded once at startup, so a newly created file needs a restart
before it shows up.")

  (setq org-agenda-files (append my/school-agenda-files my/general-agenda-files))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "STRT(s)" "|" "DONE(d)" "KILL(k)"))
        org-blank-before-new-entry '((heading . nil)
                                     (plain-list-item . nil))
        org-deadline-warning-days 7
        org-log-done 'time
        org-startup-with-inline-images t
        org-image-actual-width '(600)
        org-agenda-start-day "0d"
        org-agenda-start-on-weekday nil
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
** What did I do today?
%?
** Is there anything still on my mind?

** Did I concentrate on tasks tody?

** Did I feel energized today today?

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
        '(("o" "Open items by due date (everything)"
           ((todo "TODO|STRT"
                  ((org-agenda-overriding-header "Open — by due date")
                   (org-agenda-sorting-strategy '(deadline-up))))))
          ;; Shadows the built-in "t" (global todo list), which showed school
          ;; and general items together.
          ("t" "General todos"
           ((todo "TODO|STRT"
                  ((org-agenda-overriding-header "General todos — by due date")
                   (org-agenda-sorting-strategy '(deadline-up)))))
           ((org-agenda-files my/general-agenda-files)))
          ;; Shadows the built-in "s" (search for keywords) — that's still on S.
          ("s" "School assignments"
           ((todo "TODO|STRT"
                  ((org-agenda-overriding-header "Assignments — by due date")
                   (org-agenda-sorting-strategy '(deadline-up)))))
           ((org-agenda-files my/school-agenda-files)))))

  ;; Org never writes to disk on its own, so an edit made from the agenda
  ;; (`t d' to mark something DONE, a new deadline, a refile, ...) only
  ;; changes the file's buffer — ~/org itself stays stale until something
  ;; saves it.  Save every modified org buffer right after any agenda
  ;; command that edits one.  The list holds just the entry points that do
  ;; the editing: `org-agenda-todo-nextset', `org-agenda-priority-up', the
  ;; four archive commands and the bulk actions all funnel through these.
  (defun my/org-save-all-org-buffers (&rest _)
    "Save every modified Org buffer, without the usual echo-area chatter.
Accepts and ignores any arguments, so it can be used as :after advice."
    (let ((inhibit-message t)
          (message-log-max nil))
      (org-save-all-org-buffers)))

  (dolist (cmd '(org-agenda-todo
                 org-agenda-priority
                 org-agenda-schedule
                 org-agenda-deadline
                 org-agenda-set-tags
                 org-agenda-set-property
                 org-agenda-set-effort
                 org-agenda-toggle-archive-tag
                 org-agenda-refile
                 org-agenda-archive-with
                 org-agenda-kill
                 org-agenda-clock-in
                 org-agenda-clock-out))
    (advice-add cmd :after #'my/org-save-all-org-buffers)))

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
