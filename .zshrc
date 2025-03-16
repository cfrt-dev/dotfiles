addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export WEBKIT_DISABLE_DMABUF_RENDERER=1
export DOTNET_ROOT="$HOME/software/libraries/dotnet"
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
export VAGRANT_DEFAULT_PROVIDER="libvirt"
export VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1
export COMPOSE_BAKE=true


addToPath ~/.krew/bin
addToPath ~/go/bin
addToPath ~/.local/bin
addToPath ~/.local/scripts
addToPath ~/.bun/bin
addToPath ~/.local/share/gem/ruby/3.3.0/bin
addToPathFront $DOTNET_ROOT

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

alias tctl=talosctl
alias tf=terraform
alias btw=fastfetch
alias cdt='cd `mktemp -d`'
alias yt-dlp="yt-dlp -o \"%(title)s\""
alias cal="cal -m"
alias c=clear
alias ta="tmux attach"
alias vim=nvim
alias h=helm
alias kx="kubectx"
alias kns="kubens"
alias ka="kubectl apply -f"
alias kd="kubectl delete -f"
alias k=kubectl
alias nano=nvim
alias copy='xclip -selection clipboard'
alias ipy=ipython
alias py=python
alias finish="source /opt/finish.sh"
alias bat="bat --plain "
alias сдуфк=clear
alias yz=yazi

source $ZSH/oh-my-zsh.sh


for file in ~/.zsh_completions/*; do
    eval "$(<$file); compdef _bw bw;"
done

bindkey '^ ' autosuggest-accept
bindkey -s '^f' 'tmux-sessionizer\n'



export LD_LIBRARY_PATH=/home/cyberfather/.local/lib/arch-mojo:$LD_LIBRARY_PATH

[ -s "/home/cyberfather/.bun/_bun" ] && source "/home/cyberfather/.bun/_bun"

export PNPM_HOME="/home/cyberfather/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

