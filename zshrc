# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:~/dotfiles

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ant docker docker-compose extract gradle mvn rsync rust tmux web-search z zsh-autosuggestions tmuxinator common-aliases kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='subl'

# Standard and additional keybindings:
#   ctrl + u     : clear line
#   ctrl + w     : delete word backward
#   alt  + d     : delete word
#   ctrl + a     : move to beginning of line
#   ctrl + e     : move to end of line (e for end)
#   alt/ctrl + f : move to next word (f for forward)
#   alt/ctrl + b : move to previous word (b for backward)
#   ctrl + d     : delete char at current position (d for delete)
#   ctrl + k     : delete from character to end of line
#   alt  + .     : cycle through previous args

# key rebinds
bindkey -s '\C-l' 'clear && ls -lhG\n'
bindkey -s '\C-o' 'clear\n'

# ctrl-space
bindkey '^ ' autosuggest-execute

# ctrl-x : insert last command result
zmodload -i zsh/parameter
insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey '^x' insert-last-command-output

# expand alias: ctrl+X A

# F1
bindkey -s '\eOP' 'git status --short^M'

source ~/dotfiles/shell/.aliases
source ~/dotfiles/shell/.functions
source ~/dotfiles/shell/.external

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey -s '\C-z' 'ag -l -g "" | fzf | xargs subl\n'

# Fix VSCode Ctrl+Shift+E shortcut (https://github.com/Microsoft/vscode/issues/48480)
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export FZF_CTRL_T_COMMAND='find * -type d -name 'build' -prune -o -type d -name 'bin' -prune -name ".*" -prune  -o -type f'

export PATH=$(realpath ~/dotfiles/bin):$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/daniel/.sdkman"
[[ -s "/home/daniel/.sdkman/bin/sdkman-init.sh" ]] && source "/home/daniel/.sdkman/bin/sdkman-init.sh"
unset GRADLE_HOME
# Add Jbang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"


if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
