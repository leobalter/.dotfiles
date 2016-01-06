# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# use browserstack_key file to set your browserstack credentials
if [ -f ~/.browserstack_key ]; then
  . ~/.browserstack_key
fi

## History control
export HISTCONTROL=ignoreboth
shopt -s histappend

## PATH
# Put /usr/local/{sbin,bin} first
export PATH=/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=/Users/leobalter/dev/depot_tools:$PATH

export MOZILLA_PATH=/Users/leobalter/dev/gecko-dev/js/src/build_DBG.OBJ/dist/bin
export V8_PATH=/Users/leobalter/dev/v8/out/native

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

## NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

## Java SDK
export JAVA_HOME=$(/usr/libexec/java_home)

## Test262 Path
export TEST262_PATH=/Users/leobalter/dev/test262

# bin folders from ~, gems, and Homebrew
for another_bin in \
    $HOME/bin \
    $HOME/bin/extras
do
    [[ -e $another_bin ]] && export PATH=$another_bin:$PATH
done

if [[ -n `which brew` ]]; then
  # Find a Homebrew-built Python
  python_bin=$(brew --cellar python)/*/bin
  python_bin=`echo $python_bin`
  [[ -e $python_bin ]] && export PATH=$python_bin:$PATH

  [[ -e /usr/local/share/python ]] && export PATH=/usr/local/share/python:$PATH

  # Find a Homebrew-built Ruby
  ruby_bin=$(brew --cellar ruby)/*/bin
  ruby_bin=`echo $ruby_bin`
  [[ -e $ruby_bin ]] && export PATH=$ruby_bin:$PATH
fi

# No ._ files in archives please
export COPYFILE_DISABLE=true

## Aliases
alias cls='clear'
alias edit='open -a "Sublime Text"'
alias atom='open -a "Atom"'
alias brackets='open -a "Brackets"'
alias delpyc="find . -name '*.pyc' -delete"
alias tree='tree -Ca -I ".git|.svn|*.pyc|*.swp|node_modules"'
alias sizes='du -h -d1'
alias hljs='pbpaste | highlight --syntax=js -O rtf | pbcopy'
alias today="cal | grep -C6 --color \"$(date +%e)\""

alias flushdns="dscacheutil -flushcache"
alias js-dev='~/dev/spidermonkey/js/src/build_DBG.OBJ/dist/bin/js'
alias d8='~/dev/v8/out/native/d8'
alias test262-spidermonkey='bash ~/.dotfiles/bin/run-tests.sh ../spidermonkey/js/src/build_DBG.OBJ/dist/bin/js'
alias test262-d8='bash ~/.dotfiles/bin/run-tests.sh'

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
    /usr/local/etc/bash_completion.d/git-completion.bash \
    /usr/local/Cellar/node/0.12.7/etc/bash_completion.d/npm \
    /usr/local/Cellar/nvm/0.23.3/etc/bash_completion.d/nvm
do
    [[ -e $comp ]] && source $comp
done

## Tab Completions for grunt-cli
eval "$(grunt --completion=bash)"

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

  branch=${BASH_REMATCH[1]}

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

  echo "${remote}${remote_ff}${GREEN}(${branch})${COLOR_NONE}${git_is_dirty}${COLOR_NONE}"
}

function setWindowTitle {
  case $TERM in
    *xterm*|ansi)
      echo -n -e "\033]0;$*\007"
      ;;
  esac
}

function set_prompt {
  [[ -n $HOMEBREW_DEBUG_INSTALL ]] && \
    homebrew_prompt="${BROWN}Homebrew:${COLOR_NONE} debugging ${HOMEBREW_DEBUG_INSTALL}\n"

  git_prompt="$(parse_git_branch)"

  export PS1="[\w] ${git_prompt}${COLOR_NONE}\n${homebrew_prompt}\$ "

  # Domain is stripped from hostname
  case $HOSTNAME in
    LeoBalter-Bocoup.local)
      this_host=
      ;;
    *)
      this_host="${HOSTNAME%%.*}:"
      ;;
  esac

  setWindowTitle "${this_host}${PWD/$HOME/~}"
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

