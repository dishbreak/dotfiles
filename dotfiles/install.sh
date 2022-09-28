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

git clone --bare git@github.com:dishbreak/dotfiles.git "$CONF_DIR"

config checkout -f

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

