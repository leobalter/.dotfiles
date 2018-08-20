# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# use browserstack_key file to set your browserstack credentials
if [ -f ~/.browserstack_key ]; then
  . ~/.browserstack_key
fi

# killall gpg-agent && gpg-agent --daemon --use-standard-socket --pinentry-program /usr/local/bin/pinentry
# gpg-agent - https://github.com/pstadler/keybase-gpg-github#optional-dont-ask-for-password-every-time
# eval $(gpg-agent --daemon --pinentry-program /usr/local/bin/pinentry)

## History control
export HISTCONTROL=ignoreboth
shopt -s histappend

## PATH

export HOME_DEV=$HOME/dev

# Mono from Homebrew
export MONO_GAC_PREFIX="/usr/local"

# Put /usr/local/{sbin,bin} first
export PATH=/usr/local/bin:$PATH
# export PATH=/usr/local/opt/python/libexec/bin:$PATH
export PATH=$HOME_DEV/depot_tools:$PATH
export PATH=$HOME/bin:$PATH
# export PATH=$HOME/.yarn/bin:$PATH

# To install symlinks for compilers that will automatically use
# ccache, prepend this directory to your PATH:
export PATH=/usr/local/opt/ccache/libexec:$PATH

# https://github.com/GoogleChromeLabs/jsvu
export PATH=$HOME/.jsvu:$PATH

# export MOZILLA_PATH=$HOME_DEV/gecko-dev/js/src/build_OPT.OBJ/dist/bin
# export MOZILLA_PATH=$HOME_DEV/jsshell-mac
# export PATH=$MOZILLA_PATH:$PATH

# export V8_PATH=$HOME_DEV/v8/out.gn/x64.release
# export PATH=$V8_PATH:$PATH

# export CHAKRACORE_PATH=$HOME_DEV/ChakraCoreFiles/bin
# export PATH=$CHAKRACORE_PATH:$PATH

export PATH=$HOME_DEV/webkit/Tools/Scripts:$PATH

# export PATH=$HOME_DEV/moz-git-tools:$PATH
# export PATH=$HOME_DEV/git-cinnabar:$PATH

source ~/perl5/perlbrew/etc/bashrc

# Browser Paths
export NIGHTLY=/Applications/FirefoxNightly.app/Contents/MacOS/firefox
export FIREFOX=/Applications/Firefox.app/Contents/MacOS/firefox

# building v8
export GYP_GENERATORS=ninja

# jsc requires a path to DYLD_FRAMEWORK_PATH
# export DYLD_FRAMEWORK_PATH=$HOME_DEV/webkit/WebKitBuild/Release

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
alias mozilla-try="$HOME_DEV/gecko-dev/mach try -b do -p linux -u jsreftest -t none"

# Homebrew wontfix workaround
alias python=python2
alias pip=pip2

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

## Custom prompt
# Colors
       RED="\[\033[0;31m\]"
      PINK="\[\033[1;31m\]"
    YELLOW="\[\033[1;33m\]"
     GREEN="\[\033[0;32m\]"
  LT_GREEN="\[\033[1;32m\]"
      BLUE="\[\033[0;34m\]"
     WHITE="\[\033[1;37m\]"
    PURPLE="\[\033[1;35m\]"
      CYAN="\[\033[1;36m\]"
     BROWN="\[\033[0;33m\]"
COLOR_NONE="\[\033[0m\]"

LIGHTNING_BOLT="⚡"
      UP_ARROW="↑"
    DOWN_ARROW="↓"
      UD_ARROW="↕"
      FF_ARROW="→"
       RECYCLE="♺"
        MIDDOT="•"
     PLUSMINUS="±"

function parse_git_branch {
  branch_pattern="^On branch ([^${IFS}]*)"
  remote_pattern_ahead="Your branch is ahead of"
  remote_pattern_behind="Your branch is behind"
  remote_pattern_ff="Your branch (.*) can be fast-forwarded."
  diverge_pattern="Your branch and (.*) have diverged"

  git_status="$(git status 2> /dev/null)"
  if [[ ! ${git_status} =~ ${branch_pattern} ]]; then
    # Rebasing?
    toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
    [[ -z "$toplevel" ]] && return

    [[ -d "$toplevel/.git/rebase-merge" || -d "$toplevel/.git/rebase-apply" ]] && {
      sha_file="$toplevel/.git/rebase-merge/stopped-sha"
      [[ -e "$sha_file" ]] && {
        sha=`cat "${sha_file}"`
      }
      echo "${PINK}(rebase in progress)${COLOR_NONE} ${sha}"
    }
    return
  fi

  branch="${CYAN}${BASH_REMATCH[1]}${COLOR_NONE}"

  # Dirty?
  if [[ ! ${git_status} =~ "working directory clean" ]]; then
    [[ ${git_status} =~ "modified:" ]] && {
      git_is_dirty="${RED}${LIGHTNING_BOLT}"
    }

    [[ ${git_status} =~ "Untracked files" ]] && {
      git_is_dirty="${git_is_dirty}${PINK}${MIDDOT}"
    }

    [[ ${git_status} =~ "new file:" ]] && {
      git_is_dirty="${git_is_dirty}${LT_GREEN}+"
    }

    [[ ${git_status} =~ "deleted:" ]] && {
      git_is_dirty="${git_is_dirty}${RED}${RECYCLE}"
    }

    [[ ${git_status} =~ "renamed:" ]] && {
      git_is_dirty="${git_is_dirty}${YELLOW}→"
    }
  fi

  # Are we ahead of, beind, or diverged from the remote?
  if [[ ${git_status} =~ ${remote_pattern_ahead} ]]; then
    remote="${YELLOW}${UP_ARROW}"
  elif [[ ${git_status} =~ ${remote_pattern_ff} ]]; then
    remote_ff="${WHITE}${FF_ARROW}"
  elif [[ ${git_status} =~ ${remote_pattern_behind} ]]; then
    remote="${YELLOW}${DOWN_ARROW}"
  elif [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}${UD_ARROW}"
  fi

  echo "${remote}${remote_ff}${branch}${git_is_dirty}"
}

function setWindowTitle {
  case $TERM in
    *xterm*|ansi)
      echo -n -e "\033]0;$*\007"
      ;;
  esac
}

function set_prompt {
  if [[ ${PWD} == "${HOME_DEV}/webkit" ]]; then
    git_prompt="${YELLOW}$(git rev-parse --abbrev-ref HEAD)${COLOR_NONE}"
  else
    git_prompt="$(parse_git_branch)"
  fi

  if [[ ${git_prompt} ]]; then
    export PS1="[\w] ${git_prompt}${COLOR_NONE}\n"
  else
    export PS1="[\w]\n"
  fi

  setWindowTitle "${PWD/$HOME/~}"
}
export PROMPT_COMMAND=set_prompt

function git-root {
  root=$(git rev-parse --git-dir 2> /dev/null)
  [[ -z "$root" ]] && root="."
  dirname $root
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


# added by travis gem
[ -f /Users/leo/.travis/travis.sh ] && source /Users/leo/.travis/travis.sh
