source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# --- Prompt (Starship) ---
eval "$(starship init zsh)"

# --- Fuzzy finder ---
eval "$(fzf --zsh)"

# --- Smarter cd (zoxide) ---
eval "$(zoxide init zsh)"

# --- Aliases ---
alias ll='eza -lh'
alias la='eza -lah'
alias ls='eza'
alias cat='bat'
alias ..='cd ..'
alias ...='cd ../..'

# --- NCSU ---
alias ncsu='ssh dbbakalo@remote.eos.ncsu.edu'
