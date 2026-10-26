# Set up the prompt

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

setopt histignorealldups sharehistory extended_history

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 50000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
eval "$(dircolors -b)"
# Tone down dircolors' bright backgrounds (green/red/yellow highlight blocks).
# Later entries win, so these override the defaults loaded above.
LS_COLORS+="ow=01;34:tw=01;34:st=01;34:su=01;31:sg=01;33:pi=33:bd=01;33:cd=01;33:or=01;31:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
# Complete . and .. as ../ and ./, and always append / to directories
zstyle ':completion:*' special-dirs true
setopt auto_param_slash mark_dirs
setopt autocd

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Up / Down: search history for entries starting with what's already typed,
# instead of walking the whole history blindly.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up   (normal mode)
bindkey "^[[B" down-line-or-beginning-search # Down (normal mode)
bindkey "^[OA" up-line-or-beginning-search   # Up   (application mode, e.g. tmux)
bindkey "^[OB" down-line-or-beginning-search # Down (application mode, e.g. tmux)

# Shift-Tab cycles backwards through the completion menu.
bindkey "^[[Z" reverse-menu-complete

# CTRL left + right
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
# ALT left + right
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

typeset -U path PATH   # keep PATH free of duplicate entries
export PATH="$HOME/.local/bin:$PATH"


export EDITOR='nvim'
export VISUAL='nvim'

# pnpm
export PNPM_HOME="/home/aip/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
