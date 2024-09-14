export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="arrow" # set by `omz`

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias idd="indy deps && indy develop"
alias asl='aws sts get-caller-identity --profile nwprod.admin > /dev/null || aws sso login'
alias tfcopy="terraform show -no-color tf.plan | pbcopy"
alias tfpeek="terraform show tf.plan | less"
alias tfresh="(cd ~/src/terraform-aws && indy deps)"

if [[ "$(uname -m)" == "arm64" ]]; then
  alias abrew="/opt/homebrew/bin/brew"
  PATH="${PATH}:/opt/homebrew/bin"
fi

BULLETTRAIN_PROMPT_ORDER=(
time
status
dir
screen
git
cmd_exec_time
)

BULLETTRAIN_CONTEXT_HOSTNAME=local

PATH=${HOME}/bin:${PATH}
PATH=${HOME}/scripts:${PATH}
PATH=/usr/local/go/bin:${PATH}
PATH=/usr/local/aws/bin:${PATH}

setopt sh_word_split

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

alias dockernuke='docker kill $(docker ps -q)'
alias g='gomilk'
alias ifil='indy format && indy lint'
alias zshrc='vim ~/.zshrc'
alias zreld='. ~/.zshrc'

#set profile
set_profile() {
  export AWS_PROFILE="$1"
}

#AWS settings
export AWS_DEFAULT_REGION=us-east-1
export AWS_EC2_METADATA_DISABLED=true

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# Go
export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

COMPLETION_WAITING_DOTS="true"

export PATH="/usr/local/opt/node@10/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

function putdir() {
    mkdir "$1" && cd "$1"
}

function dockerlogin(){

    REGION=${ECR_REGION:-us-east-1}
    PROFILE=${ECR_PROFILE:-nwprod.admin}

    aws sts get-caller-identity --profile "$PROFILE" > /dev/null || awslogin admin

    ACCOUNT_ID=$(aws sts get-caller-identity --profile "$PROFILE" --query "Account" --output text)

    aws ecr get-login-password \
        --region "$REGION" --profile "$PROFILE" \
        | docker login \
        --username AWS --password-stdin \
        "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
}

export SF_ROLE=TERRAFORMOPS
export SF_REGION=us-east-1
export SF_ACCOUNT=nerdwallet

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

function mypath() {
	echo $PATH | tr ':' '\n'
}

alias k=kubectl
source <(kubectl completion zsh)
function kcurl() {
	k debug -it "$1" --image docker.nerdwallet.io/curlimages/curl -- sh
} 
export KUBE_EDITOR='code --wait'

eval "$(direnv hook zsh)"

  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.cargo/bin:$PATH"

[ -s "/Users/vishal/.scm_breeze/scm_breeze.sh" ] && source "/Users/vishal/.scm_breeze/scm_breeze.sh"

export PATH="/opt/podman/bin:$PATH"
