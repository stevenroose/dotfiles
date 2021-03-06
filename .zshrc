#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias glp="git log -p "
alias gri="git rebase --interactive --autosquash --autostash "

export PATH=$PATH:/home/steven/.local/bin

# golang config
alias gf="go fmt ./..."
export GOROOT_BOOTSTRAP=/usr/lib/go
[[ -s "/home/steven/.gvm/scripts/gvm" ]] && source "/home/steven/.gvm/scripts/gvm"
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin
alias godeps="go list -f '{{ join .Deps  \"\n\"}}' ."
alias godepsdot="go list -f '{{ join .Deps  "\n"}}' . | grep -F ."

# Rust
export PATH=$PATH:$HOME/.cargo/bin
export CARGO_TARGET_DIR=/media/data/cargo-target
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export RUST_BACKTRACE=1

# Dart config
export PATH=$PATH:$HOME/.pub-cache/bin
export PATH=$PATH:$HOME/dartcode/flutter/bin

alias tbtcctl="btcctl -C ~/.btcctl/tbtcctl.conf"

# list changed files since last commit (for use as gofmt -s ${changes})
alias changes="git diff --name-only HEAD | tr '\n' ' '"
function checkoutpr() {
	git fetch -f origin pull/$1/head:pr$1
	git checkout pr$1
}
alias amenddate="git commit --amend --date=\"\$(date -R)\""
alias recentbranches="git branch --sort=committerdate | tail"

# SSH
#ssh-agent zsh

# kubernetes
export KUBE_EDITOR="nano"

# Java home
export JAVA_HOME="/usr/lib/jvm/$(archlinux-java get)"

# pretty json
alias prettyjson='python -m json.tool'

export EDITOR="nvim"

# add ~/bin to PATH
export PATH="$PATH":"/home/steven/bin"

# Dotfiles setup
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export TERM=xterm-256color

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/steven/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux golang ssh-agent)
zstyle :omz:plugins:ssh-agent identities

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

fpath=( $HOME/.zsh/completions $fpath )
autoload -U compinit
compinit

autoload -U bashcompinit && bashcompinit
source ~/.bash_completion.d/*


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_CTRL_R_OPTS='--no-sort'


# Blockstream
export GDK_LOCATION=/home/steven/blockstream/gdk
export GDK_TARGET=build-clang

# Some Blockstream utils
function bs_less() {
    jq -c '{time: .time, severity: .severity, name: .name, data: .data, id: .log_id}'
}
function bs_code() {
    jq -c "select(.log_id | startswith(\"$1\"))" 
}
function bs_hr() {
    jq -r '"\(.time[0:19])  \(if .severity == "info" or .severity == "warn" then " " else "" end)\(.severity | ascii_upcase): \(if .log_id | startswith("L-000") then .data.message else "[\(.log_id)|\(.name)] \(.desc): \(.data)" end)"'
}
function bs_warn() {
    jq -c 'select(.severity == "error" or .severity == "warn")'
}
function bs_info() {
    jq -c 'select(.severity == "error" or .severity == "warn" or .severity == "info")'
}
function bs_debug() {
    jq -c 'select(.severity == "error" or .severity == "warn" or .severity == "info" or .severity == "debug")'
}


# Print todos to reduce procrastination.
todo

