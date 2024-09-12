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

mkdir -p "$HOME/bin"

# --bare flag here lets us check out the repo without the working dir
git clone --bare git@github.com:dishbreak/dotfiles.git "$CONF_DIR"

# config alias checks out files to the home dir, and -f overwrites existing files (useful for reinstall)
config checkout -f

# install homebrew
if ! which brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

/opt/homebrew/bin/brew install \
	shellcheck \
	nvm \
	1password-cli \
	gh \
	direnv \
	derailed/k9s/k9s \
	kubectx \
	kubectl \
	jq

# install uv
# NB we set NO_MODIFY_PATH because our dotfile should already have that set up.
curl -LsSf https://astral.sh/uv/install.sh -o install-uv.sh
chmod u+x install-uv.sh
INSTALLER_NO_MODIFY_PATH=yes ./install-uv.sh
rm install-uv.sh

# install ruff
curl -LsSf https://astral.sh/ruff/install.sh -o install-ruff.sh
chmod u+x install-ruff.sh
INSTALLER_NO_MODIFY_PATH=yes ./install-ruff.sh
rm install-ruff.sh

# install Pythons
"$HOME/.cargo/bin/uv" python install 3.9 3.10 3.12

# AWS CLI tools
if ! which aws; then
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm -f "AWSCLIV2.pkg"
fi

OMZ_DIR="$HOME/.oh-my-zsh"
if [[ -d "$OMZ_DIR" ]]; then 
    echo "removing oh-my-zsh dir"
    rm -rf "$OMZ_DIR"
fi
echo "installing oh-my-zsh"
export RUNZSH=no # don't exec ZSH in the installer pls
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

SCMB_DIR="$HOME/.scm_breeze"
if [[ -d "$SCMB_DIR"]]; then
    echo "removing scm breeze dir"
    rm -rf "$SCMB_DIR"
fi
echo "install scm_breeze"
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh

cat <<EOF
** Reminder: install the following manually
VSCode: Download Visual Studio Code at https://go.microsoft.com/fwlink/?LinkID=534106
Sidekick: Download Sideckick at https://www.meetsidekick.com/download/
Bitwarden: Download Bitwarden at https://bitwarden.com/download/#downloads-desktop
Logseq: Download Logseq at https://logseq.com/downloads
Alfred 5: Download Alfred at https://www.alfredapp.com/
Mimestream: Download at https://mimestream.com/
Telegram: Download at https://macos.telegram.org/
f.lux: Download at https://justgetflux.com/
Spotify: Download at https://www.spotify.com/de-en/download/mac/
Podman Desktop: Download at https://podman.io/


After installing VSCode, run ./setup.sh from ~/dotfiles/vscode
EOF
