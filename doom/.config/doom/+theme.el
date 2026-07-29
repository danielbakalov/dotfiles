;;; $DOOMDIR/+theme.el -*- lexical-binding: t; -*-
;;; Face fixes for kanagawa-dragon.  Loaded from config.el.
;;
;; The theme leaves a lot of faces undefined, so they fall through to Emacs'
;; stock dark-background defaults — LightSkyBlue, PaleGreen, chocolate1, pale
;; turquoise, LightGoldenrod — none of which are Kanagawa colors, and all of
;; which are far brighter than anything in the Dragon palette.  Everything
;; below is drawn from Dragon's own colors:
;;
;;   backgrounds  #181616 bg      #1D1C19 -1    #282727 +1    #393836 +2
;;   grays        #625e5a nontext #737c73 ash   #7a8382 gray3 #a6a69c gray
;;   foreground   #c5c9c5 white
;;   accents      #c4746e red     #b6927b orange #c4b28a yellow #87a987 green
;;                #8ba4b0 blue    #8992a7 violet #8ea4a2 aqua   #a292a3 pink
;;
;; To undo any single decision, delete its line and `M-x doom/reload-theme'.

;; ===========================================================================
;; Org agenda — undefined by the theme, so it was rendering in stock Emacs
;; colors.  The point of the palette below is a legibility ranking: the closer
;; something is to being late, the warmer and brighter it gets.  Everything
;; already handled recedes toward the gray used for code comments.
;; ===========================================================================
(custom-set-faces!
  ;; Day headers and the "10 days-agenda (W30-W31):" banner were LightSkyBlue.
  '(org-agenda-structure           :foreground "#8ba4b0" :weight bold)
  '(org-agenda-structure-secondary :foreground "#7a8382")
  '(org-agenda-structure-filter    :foreground "#c4746e" :weight bold)
  '(org-agenda-date                :foreground "#8ba4b0")
  '(org-agenda-date-today          :foreground "#c4b28a" :weight bold :slant italic)
  '(org-agenda-date-weekend        :foreground "#8992a7" :weight bold)
  '(org-agenda-date-weekend-today  :foreground "#c4b28a" :weight bold :slant italic)

  ;; Urgency ramp.  Deadlines inside `org-deadline-warning-days' (7) already
  ;; used the theme's orange; today/overdue was stock bright orange #FF9E3B.
  '(org-imminent-deadline          :foreground "#c4746e" :weight bold)
  '(org-upcoming-distant-deadline  :foreground "#7a8382")
  '(org-scheduled-previously       :foreground "#c4746e")   ; was chocolate1
  '(org-scheduled-today            :foreground "#c5c9c5")   ; was PaleGreen
  '(org-scheduled                  :foreground "#7a8382")   ; was PaleGreen
  '(org-agenda-done                :foreground "#737c73")   ; was PaleGreen
  '(org-agenda-dimmed-todo-face    :foreground "#625e5a")   ; blocked tasks

  ;; Time grid + "now" marker (day view).  Was LightGoldenrod.
  '(org-time-grid                  :foreground "#625e5a")
  '(org-agenda-current-time        :foreground "#c4b28a" :weight bold))

;; ===========================================================================
;; Org buffers.  Two of these were unreadable rather than merely off-palette:
;; the theme assigns `org-date' and `org-ellipsis' the color #2D4F67, which is
;; a *background* shade from the Wave variant — dark navy text on a near-black
;; background.  Src blocks were also getting a blue-tinted opening line and a
;; red-tinted closing line (the theme reuses its diff colors there), which is
;; loud in a file like finances.org that is mostly ledger blocks.
;; ===========================================================================
(custom-set-faces!
  '(org-date          :foreground "#8992a7")
  '(org-sexp-date     :foreground "#8992a7")
  '(org-ellipsis      :foreground "#737c73" :weight normal)

  ;; One quiet inset band for the whole block instead of blue-top/red-bottom.
  '(org-block             :background "#1D1C19" :extend t)
  '(org-block-begin-line  :foreground "#737c73" :background "#1D1C19" :extend t)
  '(org-block-end-line    :foreground "#737c73" :background "#1D1C19" :extend t)
  '(org-meta-line         :foreground "#737c73" :background unspecified)

  ;; Structural noise: DEADLINE:/SCHEDULED:/CLOSED: labels and :PROPERTIES:
  ;; drawers.  You read the value, not the label, so let the label recede.
  '(org-special-keyword   :foreground "#737c73" :weight normal :slant normal)
  '(org-drawer            :foreground "#737c73" :weight normal)   ; was LightSkyBlue
  '(org-property-value    :foreground "#7a8382")

  ;; Keep finished items consistent with how they now look in the agenda.
  '(org-done              :foreground "#737c73")
  '(org-headline-done     :foreground "#737c73" :strike-through t)
  '(org-headline-todo     :foreground "#c5c9c5")   ; theme set this to a bg color

  '(org-table             :foreground "#8ea4a2")   ; was LightSkyBlue
  '(org-table-header      :foreground "#c5c9c5" :background "#282727" :weight bold)
  '(org-formula           :foreground "#b6927b")   ; was chocolate1
  '(org-document-title    :foreground "#c5c9c5" :weight bold :height 1.0) ; was pale turquoise
  '(org-document-info     :foreground "#7a8382")
  '(org-document-info-keyword :foreground "#737c73")
  '(org-tag               :foreground "#7a8382" :weight normal)
  '(org-checkbox          :foreground "#8ba4b0" :weight bold)
  '(org-verbatim          :foreground "#8a9a7b")
  '(org-code              :foreground "#c4b28a" :background "#1D1C19"))

;; ===========================================================================
;; org-modern's chips.  Its defaults are literal grays (gray20/gray35/gray50/
;; gray75) with white or black text — deliberately theme-agnostic, so nothing
;; here was Kanagawa.  Timestamp chips are everywhere in calendar.org, so these
;; matter as much as the agenda does.
;; ===========================================================================
(custom-set-faces!
  '(org-modern-done              :foreground "#737c73" :background "#393836")
  '(org-modern-tag               :foreground "#a6a69c" :background "#393836")
  '(org-modern-date-active       :foreground "#a6a69c" :background "#282727")
  ;; :distant-foreground is cleared because org-modern's defaults set it to
  ;; black/white, which is what shows through when hl-line or a region covers
  ;; the chip — otherwise a selected timestamp flips to a non-palette color.
  '(org-modern-time-active       :foreground "#c5c9c5" :background "#393836"
                                 :distant-foreground unspecified)
  '(org-modern-date-inactive     :foreground "#737c73" :background "#1D1C19")
  '(org-modern-time-inactive     :foreground "#737c73" :background "#282727"
                                 :distant-foreground unspecified)
  '(org-modern-progress-complete :foreground "#181616" :background "#87a987")
  '(org-modern-progress-incomplete :foreground "#a6a69c" :background "#393836")
  '(org-modern-horizontal-rule   :underline "#393836" :extend t)
  '(org-modern-block-name        :foreground "#737c73"))

;; ===========================================================================
;; Theme bugs outside org.
;; ===========================================================================
(custom-set-faces!
  ;; `shadow' is Emacs' standard "de-emphasized text" face, but the theme
  ;; defines it as a *background* with no foreground — so dimmed text (cleared
  ;; ledger payees, org-verbatim, dired-ignored, consult annotations) rendered
  ;; at full brightness inside a black box.  Make it an actual dim foreground.
  ;; `:inherit nil' is load-bearing — the background arrives via the theme's
  ;; `:inherit separator-line', so clearing :background alone doesn't drop it.
  '(shadow :foreground "#625e5a" :background unspecified :inherit nil)

  ;; A mismatched paren was dark gray, i.e. easy to miss entirely.
  '(show-paren-mismatch :foreground "#181616" :background "#c4746e" :weight bold)

  ;; The gutter had its own lighter background (#282727), drawing a stripe down
  ;; the left of every buffer.  Blend it, and mark the current line — with
  ;; relative numbers that's the one number you actually read.
  '(line-number              :foreground "#625e5a" :background "#181616")
  '(line-number-current-line :foreground "#c4b28a" :background "#393836" :weight bold)

  ;; Splits were divided by #1D1C19, near-invisible against the #181616 bg.
  '(vertical-border :foreground "#282727")
  '(window-divider  :foreground "#282727"))

;; ===========================================================================
;; The one opinionated change: `error'/`warning'/`success' come from the shared
;; Kanagawa base palette, not Dragon's, so they were #E82424 / #FF9E3B /
;; #98BB6C — three of the most saturated colors in the whole theme, dropped
;; into an otherwise muted variant.  Dragon defines its own red/yellow/green;
;; these use those instead.  Affects hl-todo TODO/FIXME, uncleared ledger
;; payees, and other inheritors.  Delete this block to get the loud ones back.
;; ===========================================================================
(custom-set-faces!
  '(error   :foreground "#c4746e" :weight bold)
  '(warning :foreground "#c4b28a" :weight bold)
  '(success :foreground "#87a987" :weight bold))
