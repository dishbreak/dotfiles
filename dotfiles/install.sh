#!/bin/bash

set -e

echo "moving existing config files"

mv .bashrc .bashrc.bak || echo "no .bashrc"
mv .zshrc .zshrc.bak || echo "no .zshrc"

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore

CONF_DIR="$HOME/.cfg"
if [[ -d "$CONF_DIR" ]]; then
    echo "removing prior config dir"
    rm -rf "$CONF_DIR"
fi

# --bare flag here lets us check out the repo without the working dir
git clone --bare git@github.com:dishbreak/dotfiles.git "$CONF_DIR"

# config alias checks out files to the home dir, and -f overwrites existing files (useful for reinstall)
config checkout -f

BREWCMD="brew_not_found"
case "$(uname -m)" in 
    arm64)
        BREWCMD="/opt/homebrew/bin/brew"
        ;;
    amd64)
        BREWCMD="/usr/local/bin/brew"
        ;;
esac

"$BREWCMD" install rbenv pyenv

# AWS CLI tools
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm -f "AWSCLIV2.pkg"

OMZ_DIR="$HOME/.oh-my-zsh"
if [[ -d "$OMZ_DIR" ]]; then 
    echo "removing oh-my-zsh dir"
    rm -rf "$OMZ_DIR"
fi
echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

SCMB_DIR="$HOME/.scm_breeze"
if [[ -d "$SCMB_DIR"]]; then
    echo "removing scm breeze dir"
    rm -rf "$SCMB_DIR"
fi
echo "install scm_breeze"
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh

