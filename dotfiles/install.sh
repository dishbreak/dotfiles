#!/bin/bash

set -e

echo "moving existing config files"

mv .bashrc .bashrc.bak || echo "no .bashrc"
mv .zshrc .zshrc.bak || echo "no .zshrc"

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore

git clone --bare git@github.com:dishbreak/dotfiles.git $HOME/.cfg

config checkout

echo "installing zshrc"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

echo "install scm_breeze"
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh

