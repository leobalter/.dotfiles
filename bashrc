# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source ~/.bash_prompt

# use browserstack_key file to set your browserstack credentials
if [ -f ~/.browserstack_key ]; then
  . ~/.browserstack_key
fi

# killall gpg-agent && gpg-agent --daemon --use-standard-socket --pinentry-program /usr/local/bin/pinentry
# gpg-agent - https://github.com/pstadler/keybase-gpg-github#optional-dont-ask-for-password-every-time
if test -f "${HOME}/.gpg-agent-info"; then
  source "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  GPG_TTY=$(tty)
  export GPG_TTY
else
  eval $(gpg-agent --daemon \
    --use-standard-socket \
    --pinentry-program /usr/local/bin/pinentry \
    --write-env-file "${HOME}/.gpg-agent-info")
fi

## History control
export HISTCONTROL=ignoreboth
shopt -s histappend

## PATH
# Put /usr/local/{sbin,bin} first
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/dev/depot_tools:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.yarn/bin:$PATH

# To install symlinks for compilers that will automatically use
# ccache, prepend this directory to your PATH:
export PATH=/usr/local/opt/ccache/libexec:$PATH

export MOZILLA_PATH=$HOME/dev/gecko-dev/js/src/build_OPT.OBJ/dist/bin
export PATH=$MOZILLA_PATH:$PATH
export V8_PATH=$HOME/dev/v8/out.gn/x64.release
export PATH=$V8_PATH:$PATH

export PATH=$HOME/dev/moz-git-tools:$PATH

# building v8
export GYP_GENERATORS=ninja

## NVM
# export NVM_DIR="$HOME/.nvm"
# . "$(brew --prefix nvm)/nvm.sh"

# No ._ files in archives please
export COPYFILE_DISABLE=true

## Aliases
alias cls='clear'
alias edit='open -a "Sublime Text"'
alias code='open -a "Visual Studio Code"'
alias tree='tree -Ca -I ".git|.svn|*.pyc|*.swp|node_modules"'
alias sizes='du -h -d1'
alias hljs='pbpaste | highlight --syntax=js -O rtf | pbcopy'
alias today="cal | grep -C6 --color \"$(date +%e)\""
alias psync="npm install && npm prune && npm update"
alias flushdns='dscacheutil -flushcache'

alias connect-irc="ssh -i irssi.pem leobalter@54.89.155.61"

function show-empty-folders {
    find . -depth -type d -empty
}

function kill-empty-folders {
    find . -depth -type d -empty -exec rmdir "{}" \;
}

## Tab Completions
set completion-ignore-case On

for comp in \
    /usr/local/etc/bash_completion \
    /usr/local/etc/bash_completion.d/git-completion.bash
do
    [[ -e $comp ]] && source $comp
done

## Alias hub to git
eval "$(hub alias -s)"

function setWindowTitle {
  case $TERM in
    *xterm*|ansi)
      echo -n -e "\033]0;$*\007"
      ;;
  esac
}

# Open a manpage in Preview, which can be saved to PDF
function pman {
   man -t "${1}" | open -f -a /Applications/Preview.app
}

# Open a manpage in the browser
function bman {
  man "${1}" | man2html | browser
}

function pgrep {
  local exclude="\.svn|\.git|\.swp|\.coverage|\.pyc|_build"
  find . -maxdepth 1 -mindepth 1 | egrep -v "$exclude" | xargs egrep -lir "$1" | egrep -v "$exclude" | xargs egrep -Hin --color "$1"
}

