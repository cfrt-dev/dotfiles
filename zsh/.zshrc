# zmodload zsh/zprof

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

autoload -U select-word-style
select-word-style bash

autoload -Uz compinit
ZCD=${ZDOTDIR:-$HOME}/.zcompdump

if [[ -n $ZCD(#qNmh+24) ]]; then
  compinit -d $ZCD
else
  compinit -C -d $ZCD   # skip security audit on the fast path
fi

# Recompile the dump in the background if stale
{
  [[ -s $ZCD && (! -s ${ZCD}.zwc || $ZCD -nt ${ZCD}.zwc) ]] && zcompile $ZCD
} &!

# Enable interactive completion menu selection
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"

bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^R' history-incremental-search-backward
bindkey '^ ' autosuggest-accept
bindkey -s '^F' 'tmux-sessionizer\n'
bindkey $'\e[1;5D' backward-word
bindkey $'\e[1;5C' forward-word
bindkey $'\e[5D' backward-word
bindkey $'\e[5C' forward-word

export VIRTUAL_ENV_DISABLE_PROMPT=1

eval "$(starship init zsh)"

# zprof
