# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
HIST_STAMPS="yyyy-mm-dd"
# zsh plugins
plugins=(macos git gh web-search npm volta)

source $ZSH/oh-my-zsh.sh

# Put /usr/local/{sbin,bin} first
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PATH=$HOME/.esvu/bin:$PATH
export PATH=$HOME/dev/WebKit/Tools/Scripts:$PATH

# No ._ files in archives please
export COPYFILE_DISABLE=true

eval "$(/opt/homebrew/bin/brew shellenv)"

# Forward git agent
ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 &>/dev/null

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

# Homebrew wontfix workaround
alias python=python3
alias pip=pip3

## Tab Completions
set completion-ignore-case On

function pgrep {
  local exclude="\.svn|\.git|\.swp|\.coverage|\.pyc|_build"
  find . -maxdepth 1 -mindepth 1 | egrep -v "$exclude" | xargs egrep -lir "$1" | egrep -v "$exclude" | xargs egrep -Hin --color "$1"
}

# Brew completions
# https://docs.brew.sh/Shell-Completion
if command -v brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"

  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  autoload -Uz compinit
  compinit
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export GPG_TTY=$(tty)
# gpgconf --launch gpg-agent
