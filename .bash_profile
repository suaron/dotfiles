#!/usr/bin/env bash

#--------
# EXPORTS
#--------

# Make vim the default editor.
export EDITOR='vim'

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='erasedups:ignoreboth';

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Prefer US English and use UTF-8.
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Highlighting inside manpages and elsewhere.
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#--------
# PATHS
#--------

# Build, dedupe and then export PATH.
PATH="$HOME/.bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/sbin"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# ligpq psql/pg_dump etc
PATH=" /usr/local/opt/libpq/bin:$PATH"

# Node -- use project specific binaries before global ones.
# PATH="node_modules/.bin:vendor/bin:$HOME/.node-global-modules/bin:$PATH"

# rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# Dedupe using awk.
if hash awk 2>/dev/null; then
  PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')
fi;

export PATH

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

#--------
# ALIASES
#--------

# Rails
alias be="bundle exec "

alias gitlog="git reflog --pretty=raw | tig --pretty=raw"

# Flush Directory Service cache
alias flushdns="killall -HUP mDNSResponder"

# Show/hide hidden files in Finder
alias showhidden="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

alias fix='echo -e "\033c" ; stty sane; setterm -reset; reset; tput reset; clear'

# Reload the shell (i.e. invoke as a login shell)
alias reloadbash="exec ${SHELL} -l"

# Always use color output for `ls`
if hash gls 2>/dev/null; then
  # use gls from gnu coreutils
  colorflag="--color"
  export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
  eval $(gdircolors -b "$HOME/.dircolors")

  alias ls="command gls ${colorflag}"
else
  # use good old bsd ls
  colorflag="-G"
  export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'

  alias ls="command ls ${colorflag}"
fi;

# List all files colorized
alias ll="ls -la ${colorflag}"

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List only directories
alias lsd="ls -l | grep --color=never '^d'"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Silver Searcher
alias ag='ag -f --hidden'

# Recursively delete `.DS_Store` files
alias dscleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash=" \
  sudo rm -rfv /Volumes/*/.Trashes; \
  sudo rm -rfv $HOME/.Trash; \
  sudo rm -rfv /private/var/log/asl/*.asl; \
  sqlite3 $HOME/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent' \
"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"

# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

#--------
# FUNCTIONS
#--------

# grep by file name
ff(){
  find . | grep $@
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# ------
# Bash Prompt Invitation
# ------

# <new line><user>:<current_directory> git_branch <new line> <prompt>
export PS1="\n\u:\w \[\e[1;32m\]\$(__git_ps1 '%s')\[\e[0m\] \n→ "

# Aliases are not expanded when the shell is not interactive, unless the expand_aliases shell option is set using shopt
shopt -s expand_aliases

# Case-insensitive globbing (used in pathname expansion).
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it.
shopt -s histappend

# Save multi-line commands as one command.
shopt -s cmdhist

# Autocorrect typos in path names when using `cd`.
shopt -s cdspell

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# ---------------
# BASH COMPLETION
# ---------------

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

source "$(brew --prefix)/etc/bash_completion.d/brew"

source "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash";

source "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"

if hash poetry 2>/dev/null; then
  eval "poetry completions bash > $(brew --prefix)/etc/bash_completion.d/poetry.bash-completion";
fi

[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" $HOME/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add `killall` tab completion for common apps.
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTerm2 iTunes SystemUIServer Terminal Twitter" killall;

# z beats cd most of the time. `brew install z`
zpath="$(brew --prefix)/etc/profile.d/z.sh"
[ -s $zpath ] && source $zpath

# Enable history expansion with space.
# e.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# asdf
source "$(brew --prefix asdf)/asdf.sh";

# pyevnv
if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)";
fi

if hash pyenv-virtualenv-init 2>/dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi

# rbenv
if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)";
fi

# z beats cd most of the time. `brew install z`
zpath="$(brew --prefix)/etc/profile.d/z.sh"
[ -s $zpath ] && source $zpath

# Enable history expansion with space.
# e.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
