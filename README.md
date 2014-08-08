# My Dot Files

Forked from somewhere, not tested on non-OS/X environments

Before installing, check some utilities below.

```bash
# install Homebrew from http://brew.sh/index.html
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

# install git > 2.0.0, node > 0.10, vim > 7.4
brew install git node vim
```

Other tools:

```bash
brew install lynx wget zsh ack phantomjs hub tree highlight
```

After cloning this repo, remember to run install to set dotfiles links and install vim packages:

```bash
# assuming you the the clone to ~/.dotfiles
cd .dotfiles
sh install
```
