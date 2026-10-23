# history
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# completion
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# aliases and functions
source "$ZDOTDIR/aliases.zsh"
for f in "$ZDOTDIR"/functions/*.zsh(N); do
    source "$f"
done
unset f

# tools
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# plugins (keep syntax-highlighting last)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
