export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="awesomepanda"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias idd="indy deps && indy develop"
alias aa="awslogin admin"
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

export PATH="${HOME}/.rbenv/shims:${PATH}"
eval "$(rbenv init -)"
rbenv shell 2.4.1

export PATH="/Users/vkotcherlakota/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

setopt sh_word_split

source /usr/local/bin/aws_zsh_completer.sh
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

function dockerlogin(){

    REGION=${ECR_REGION:-us-east-1}
    PROFILE=${ECR_PROFILE:-nwprod}

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
