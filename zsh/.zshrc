# history
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# completion
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# aliases and functions
source "$ZDOTDIR/aliases.zsh"
for f in "$ZDOTDIR"/functions/*.zsh(N); do
    source "$f"
done
unset f

# vi mode and keybinds (before tools, so fzf and starship hook in afterwards)
source "$ZDOTDIR/keybinds.zsh"

# tools
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
source <(fzf --zsh)
eval "$(starship init zsh)"

# Angular CLI completion, loaded on first use (loading it eagerly costs ~0.4s per shell)
ng() { unfunction ng; source <(command ng completion script); ng "$@"; }

# plugins (keep syntax-highlighting last)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^f' autosuggest-accept          # Ctrl-f accepts the grey suggestion
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
