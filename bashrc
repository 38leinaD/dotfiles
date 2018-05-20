if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Make sure resize does not mess up terminal
shopt -s checkwinsize

# expand aliases
shopt -s expand_aliases

source ~/dotfiles/ext/cd.sh

# https://lug.fh-swf.de/shell/#bookmarks
source ~/dotfiles/ext/bookmarks.sh

# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/dotfiles/ext/git_autocomplete.sh

# https://github.com/juven/maven-bash-completion
source ~/dotfiles/ext/mvn_autocomplete.sh

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias ll='ls -lG'                              # long list
alias la='ls -lAG'                              # all but . and ..
alias lsd='ls -d */'                  # list subdirs only

alias gg='grep --color'                     # show differences in colour
alias ee='egrep --color=auto'              # show differences in colour
alias ff='fgrep --color=auto'              # show differences in colour

# Dev
alias mvn-deps='mvn dependency:resolve'
alias mvn-depls='mvn dependency:list'
alias mvn-depstree='mvn dependency:tree -Dverbose=true'
alias mvn-eff='mvn help:effective-pom'

bind -x '"\C-l": clear; ll'

mvn-help() { mvn help:describe -Dfull -Dplugin=$1; }

jrun() { javac $1 && java ${1%.*}; }

# docker
dme() { eval $(docker-machine env $1); }

if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/daniel/.sdkman"
[[ -s "/home/daniel/.sdkman/bin/sdkman-init.sh" ]] && source "/home/daniel/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
