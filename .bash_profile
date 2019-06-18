export PATH=~/.bin:$PATH
export PATH=~/.local/bin:$PATH

# locale stuff
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
set encoding=utf-8 nobomb

export EDITOR='vim'

if [[ "$TERM_PROGRAM" =~ iTerm|Apple_Terminal ]] && [[ -x "`which vim`" ]]; then
  export EDITOR='vim'
  export BUNDLER_EDITOR='vim'
  export GEM_EDITOR='vim'
fi

# history
export HISTCONTROL=ignoreboth:erasedups # don't put duplicate lines in the history.s
export HISTFILESIZE=3000
export HISTIGNORE="ls:cd:[bf]g:exit:..:...:ll:lla"
shopt -s histappend # Append to the Bash history file, rather than overwriting it

shopt -s expand_aliases

alias server='ruby -run -e httpd -- -p 5000 .'

# autofix typos
shopt -s cdspell

# aliases
alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups

# disk usage with human sizes
alias du1='du -hs'

# lists folders and files sizes in the current folder
alias ducks='du -cksh * | sort -rn|head -11'

alias ll='ls -AFGHhl'

alias reloadbash='source ~/.bash_profile'

alias be="bundle exec"

alias gitlog="git reflog --pretty=raw | tig --pretty=raw"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

if [ -f `brew --prefix`/etc/bash_completion ]; then
  source `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
  source `brew --prefix`/etc/bash_completion.d/vagrant
fi

if [ -f `brew --prefix`/etc/bash_completion.d/docker ]; then
  source `brew --prefix`/etc/bash_completion.d/docker
fi

if [ -f `brew --prefix`/etc/bash_completion.d/brew ]; then
  source `brew --prefix`/etc/bash_completion.d/brew
fi

# Invitation
# <new line><user>:<current_directory> git_branch <new line> <prompt>
export PS1="\n\u:\w \[\e[1;32m\]\$(__git_ps1 '%s')\[\e[0m\] \n→ "

# node version manager
if [ -f /usr/local/opt/nvm/nvm.sh ]; then
  export NVM_DIR="$HOME/.nvm"
  . /usr/local/opt/nvm/nvm.sh
fi

[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
export PATH="node_modules/.bin:$PATH"

[[ -r /usr/local/opt/pyenv/completions/pyenv.bash ]] && . /usr/local/opt/pyenv/completions/pyenv.bash
eval "$(pyenv init -)"

# grep by file name
ff(){
  find . | grep $@
}

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

alias restart_finder='killall Finder'
alias show_files="defaults write com.apple.finder AppleShowAllFiles YES && restart_finder"
alias hide_files="defaults write com.apple.finder AppleShowAllFiles NO && restart_finder"


export PATH="/Users/dima/.rbenv/shims:${PATH}"
export RBENV_SHELL=bash
source '/usr/local/Cellar/rbenv/1.1.2/libexec/../completions/rbenv.bash'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

#asdf Elixir and Erlang
source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

alias fix='echo -e "\033c" ; stty sane; setterm -reset; reset; tput reset; clear'

complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/Users/dima/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;
