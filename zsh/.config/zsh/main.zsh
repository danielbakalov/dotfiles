# --- Completions ---
autoload -Uz compinit && compinit

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# --- Prompt (starship) ---
eval "$(starship init zsh)"

# --- Searchable shell history (atuin) ---
eval "$(atuin init zsh)"

# --- Smarter cd (zoxide) ---
eval "$(zoxide init zsh)"

# --- Auto-activate virtual envs (direnv) ---
eval "$(direnv hook zsh)"

# --- Finances ---
export LEDGER_FILE="$HOME/org/finances.org"

# --- NCSU ---
alias ncsu='ssh dbbakalo@remote.eos.ncsu.edu'
get_csc230() {
  scp "dbbakalo@remote.eos.ncsu.edu:/mnt/coe/workspace/csc/CSC230/$1/$2/*" .
}

# --- Plugins ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
