if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

## Source any local additions
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
