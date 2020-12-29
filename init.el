(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf" "public_repos")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq custom-file (locate-user-emacs-file "custom.el"))

(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))

(load custom-file)

(require 'init-loader)
(require 'cl-lib)
(init-loader-load "~/.emacs.d/conf")
(define-key global-map (kbd "C-m") 'newline-and-indent)

(global-set-key (kbd "C-t") 'other-window)

(setenv "TERM" "xterm-256color")

(defun enable-line-numbers ()
  "Turn on line number display."
  (setq-local display-line-numbers t))

;; explicitly enable line numbers modes
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'enable-line-numbers))

(line-number-mode t)
(column-number-mode t)

;;(load-theme 'sanityinc-tomorrow-night)
(require 'doom-themes)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

(load-theme 'doom-one)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
  
;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
  
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(when (require 'multi-term)
  (setq multi-term-program "/bin/zsh"))

(multi-term-dedicated-open)

(set-face-attribute 'default nil
		    :family "MesloLGS NF"
		    :height 120)

(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)

(require 'all-the-icons)

(require 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(global-set-key [f8] 'neotree-toggle)
(setq neo-show-hidden-files t)
(setq neo-smart-open t)

(defun show-neotree ()
  "open neotree without change a buffer"
  (let ((cw (selected-window)))
    (neotree-show)
    (select-window cw)
  )
)

(add-hook 'emacs-startup-hook 'show-neotree)

(require 'powerline)
(powerline-center-theme)

;; メニューバーを非表示
(menu-bar-mode nil)

;; ツールバーを非表示
(tool-bar-mode nil)

(scroll-bar-mode -1)

;; 対応する括弧をハイライト
(show-paren-mode t)

;; リージョンのハイライト
(transient-mark-mode t)

;; タイトルにフルパス表示
(setq frame-title-format "%f")

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message 1)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; スクロールは1行ごとに
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))

;; スクロールの加速をやめる
(setq mouse-wheel-progressive-speed nil)

(setq ring-bell-function 'ignore)

(recentf-mode t)
(defun insert-char-ascii-art ()
  "坊やだからさ..."
  (with-current-buffer "*scratch*"
    (goto-char (1- (point-max)))
    (insert "
;; 坊やだからさ…
;;
;; 　　 ／￣￣￣＼_
;; 　 ／　　　　　 ＼
;;`／　　　　　　　 ヽ
;; ７　　　 /ﾊｉ　　　|
;; (　 ／/／ /人　　　|
;; | f￣￣八￣￣ヽ　 リ
;; ヽヽ_／/ ＼＿ノ　 ﾉ
;; 　)ﾊ　<_　　_ﾉﾉ　/
;; `幺人　==- ヽ＿／＼
;; /　／＼＿＿／　/　|＼
;; 　 ＞ />-＜　 /　 |
;; |￣￣| |＿/＼/　＿|
;; /⊃＿| | ｜ /　 ＼
;; /二ヽ| ﾊ ｜/　　 /
;; ￣二ﾌ|/　 /　　／
;; 　 厂　 ／　 ／
")))

(insert-char-ascii-art)

(require 'dashboard)
(dashboard-setup-startup-hook)

(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-center-content t)

(require 'twittering-mode)
(setq twittering-icon-mode t)
(setq twittering-use-master-password t)
(setq epa-pinentry-mode 'loopback)
(defalias 'epa--decode-coding-string 'decode-coding-string)

(require 'which-key)
(which-key-mode)

(require 'volatile-highlights)
(volatile-highlights-mode t)

(beacon-mode t)

(setq beacon-color "#1e90ff")

(require 'git-gutter)

;; If you enable global minor mode
(global-git-gutter-mode t)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(golden-ratio-mode t)
(add-to-list 'golden-ratio-exclude-buffer-names " *NeoTree*")

(setq case-fold-search t)
(setq completion-ignore-case t)
;バッファ自動再読み込み
(global-auto-revert-mode 1)

(add-hook 'after-init-hook 'global-company-mode)

(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
