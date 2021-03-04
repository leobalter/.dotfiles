if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

export PATH="$HOME/.cargo/bin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
