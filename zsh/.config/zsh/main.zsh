# --- Completions ---
autoload -Uz compinit && compinit

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS  # a repeated command replaces its older copies
setopt HIST_IGNORE_SPACE     # lines starting with a space stay out of history
setopt SHARE_HISTORY

# --- Rust (rustup/cargo) ---
. "$HOME/.cargo/env"

# --- Prompt (Starship) ---
eval "$(starship init zsh)"

# --- Fuzzy finder ---
eval "$(fzf --zsh)"

# --- Searchable shell history (after fzf, so atuin owns Ctrl-R) ---
eval "$(atuin init zsh)"

# --- Smarter cd (zoxide) ---
eval "$(zoxide init zsh)"

# --- Auto-activate virtual envs (direnv) ---
eval "$(direnv hook zsh)"

# --- Aliases ---
alias ll='eza -lh'
alias la='eza -lah'
alias ls='eza'
alias cat='bat'
alias ..='cd ..'
alias ...='cd ../..'

# --- NCSU ---
alias ncsu='ssh dbbakalo@remote.eos.ncsu.edu'
get_csc230() {
  scp "dbbakalo@remote.eos.ncsu.edu:/mnt/coe/workspace/csc/CSC230/$1/$2/*" .
}

# --- Plugins: autosuggestions late, syntax-highlighting always LAST ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Greeting on fresh interactive shells (not a plugin, safe after the sources) ---
fastfetch
