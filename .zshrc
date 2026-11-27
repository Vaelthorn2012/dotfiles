alias neofetch='fastfetch -c examples/16'

# --- 1. PLUGIN MANAGER (Zinit - Auto-installs if missing) ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
declare -A ZINIT
ZINIT[NO_ALIASES]=1
source "${ZINIT_HOME}/zinit.zsh"

# --- 2. PLUGINS (Turbo-loaded for instant startup) ---
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab

# --- 3. HISTORY & KEYBINDS ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# --- 4. COMPLETION STYLING (TokyoNight + fzf-tab) ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'

# --- 5. TOKYONIGHT FZF & SYNTAX COLORS ---
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#283457,bg:#090a0f,spinner:#bb9af7,hl:#f7768e \
  --color=fg:#d5defd,header:#f7768e,info:#e0af68,pointer:#7dcfff \
  --color=marker:#9ece6a,fg+:#ffffff,prompt:#7aa2f7,hl+:#f7768e \
  --border=rounded --height=40% --layout=reverse"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#565f89"

# --- 6. MODERN CLI ALIASES (eza, ripgrep, zoxide) ---
# eza (with Nerd Font icons & git status)
if command -v eza &> /dev/null; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza -lh --icons=always --group-directories-first --git'
  alias la='eza -lah --icons=always --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons=always'
  alias lta='eza --tree --level=2 -a --icons=always'
fi

# ripgrep (smart-case, hidden files included, ignores .git)
if command -v rg &> /dev/null; then
  alias grep='rg'
  alias rg='rg --smart-case --hidden --glob "!.git/*"'
fi

# zoxide (replaces cd seamlessly + interactive fuzzy jump with zi)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# General QoL
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias v='nvim'
alias cat='bat --theme="TwoDark" --style=plain'

# --- 7. INIT STARSHIP & FZF ---
command -v fzf &> /dev/null && source <(fzf --zsh)
command -v starship &> /dev/null && eval "$(starship init zsh)"

# Sync oxwm, rofi, dunst configs and scripts to ~/dotfiles and GitHub
alias dotsync='$HOME/dotfiles/bin/dotsync.sh'
