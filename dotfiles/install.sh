#!/bin/bash

set -ex

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

# add homebrew taps
brew tap ankitpokhrel/jira-cli

/opt/homebrew/bin/brew install \
	shellcheck \
	nvm \
	1password-cli \
	gh \
	direnv \
	derailed/k9s/k9s \
	kubectx \
	kubectl \
	postgresql \
	bitwarden \
	ngrok/ngrok/ngrok \
	jira-cli \
	helm \
	csvkit \
	opslevel/tap/cli \
	coreutils \
	jq \
	yq \
	gitu \
	kube-ps1

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
/opt/homebrew/bin/pyenv install 3.9 3.10 3.11
/opt/homebrew/bin/pyenv global 3.9

# install Docker Desktop
if ! which docker; then
	curl -fsSL "https://desktop.docker.com/mac/main/arm64/Docker.dmg" -o "Docker.dmg"
	sudo hdiutil attach Docker.dmg
	sudo cp -R "/Volumes/Docker/Docker.app" /Applications
	sudo hdiutil detach "/Volumes/Docker"
	rm -f "Docker.dmg"
fi

# AWS CLI tools
if ! which aws; then
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm -f "AWSCLIV2.pkg"
fi

# AWS SAM CLI
if ! which sam; then
curl "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-macos-arm64.pkg" -o "aws-sam-cli-macos-arm64.pkg"
sudo installer -pkg "aws-sam-cli-macos-arm64.pkg" -target /
rm -f "aws-sam-cli-macos-arm64.pkg"
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
if [[ -d "$SCMB_DIR" ]]; then
    echo "removing scm breeze dir"
    rm -rf "$SCMB_DIR"
fi
echo "install scm_breeze"
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh

# install go
echo "installing go"
INSTALL_GO_VERSION="1.23.1"
GO_VERSION_CHECK=$(go version | grep "go version go$INSTALL_GO_VERSION darwin/arm64")
if [[ -z "$GO_VERSION_CHECK" ]]; then
	GO_PKG_FILENAME="go${INSTALL_GO_VERSION}.darwin-arm64.pkg"
	curl -LsSf "https://go.dev/dl/$GO_PKG_FILENAME" -o "$GO_PKG_FILENAME"
	sudo installer -pkg "./$GO_PKG_FILENAME" -target /
	rm -f "$GO_PKG_FILENAME"
fi

# install kind
echo "installing kind"
if ! which kind; then
	curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-darwin-arm64
	chmod +x ./kind
	mv ./kind /usr/local/bin/kind
fi

# install VSCode
echo "installing VSCode"
if ! which code; then
	curl -fsSL "https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64" -o "vscode.zip"
	unzip vscode.zip
	mv "Visual Studio Code.app" /Applications
	rm -f vscode.zip

	curl -fsSL "https://code.visualstudio.com/sha/download?build=stable&os=cli-darwin-arm64" -o "vscode-cli.zip"
	unzip vscode-cli.zip
	mv "code" "$HOME/bin"
	rm -f vscode-cli.zip

	(
		echo "installing VSCode extensions"
		cd "$HOME/dotfiles/vscode"
		./setup.sh install
	)
fi

# install sidekick browser
echo "installing sidekick browser"
if [[ ! -d /Appplications/Sidekick.app ]]; then
	curl -fsSL "https://api.meetsidekick.com/downloads/macm1" -o "sidekick.dmg"
	sudo hdiutil attach sidekick.dmg
	sudo cp -R "/Volumes/Sidekick/Sidekick.app" /Applications
	sudo hdiutil detach "/Volumes/Sidekick"
	rm -f "sidekick.dmg"
fi

# install Logseq
echo "installing Logseq"
if [[ ! -d /Applications/Logseq.app ]]; then
	curl -fsSL "https://github.com/logseq/logseq/releases/download/0.10.9/Logseq-darwin-arm64-0.10.9.dmg" -o "Logseq.dmg"
	sudo hdiutil attach Logseq.dmg
	sudo cp -R "/Volumes/Logseq/Logseq.app" /Applications
	sudo hdiutil detach "/Volumes/Logseq"
	rm -f "Logseq.dmg"
fi

# install Alfred 5
ALFRED_VERSION="5.5_2257"
echo "installing Alfred 5"
if [[ ! -d /Applications/Alfred\ 5.app ]]; then
	curl -fsSL "https://cachefly.alfredapp.com/Alfred_${ALFRED_VERSION}.dmg" -o "Alfred.dmg"
	sudo hdiutil attach Alfred.dmg
	sudo cp -R "/Volumes/Alfred/Alfred 5.app" /Applications
	sudo hdiutil detach "/Volumes/Alfred"
	rm -f "Alfred.dmg"
fi

# install Mimestream
echo "installing Mimestream"
if [[ ! -d /Applications/Mimestream.app ]]; then
	curl -fsSL "https://download.mimestream.com/Mimestream_1.3.8.dmg" -o "Mimestream.dmg"
	sudo hdiutil attach Mimestream.dmg
	sudo cp -R "/Volumes/Mimestream/Mimestream.app" /Applications
	sudo hdiutil detach "/Volumes/Mimestream"
	sudo rm -f "Mimestream.dmg"
fi

# install Spotify
echo "installing Spotify"
if [[ ! -d /Applications/Spotify.app ]]; then 
	curl -fsSL "https://download.scdn.co/Spotify.dmg" -o "Spotify.dmg"
	sudo hdiutil attach Spotify.dmg
	sudo cp -R "/Volumes/Spotify/Spotify.app" /Applications
	sudo hdiutil detach "/Volumes/Spotify"
	rm -f "Spotify.dmg"
fi

# install f.lux
echo "installing f.lux"
if [[ ! -d /Applications/Flux.app ]]; then
	curl -fsSL "https://justgetflux.com/mac/Flux.zip" -o "Flux.zip"
	unzip Flux.zip
	mv "Flux.app" /Applications
	rm -f Flux.zip
fi

# install Telegram
echo "installing Telegram"
if [[ ! -d /Applications/Telegram.app ]]; then
	curl -fsSL "https://osx.telegram.org/updates/Telegram.dmg" -o "Telegram.dmg"
	sudo hdiutil attach Telegram.dmg
	sudo cp -R "/Volumes/Telegram/Telegram.app" /Applications
	sudo hdiutil detach "/Volumes/Telegram"
	rm -f "Telegram.dmg"
fi

#install Terraform
echo "installing Terraform"
if [[ ! -f "$HOME/bin/terraform" ]]; then
	curl 
