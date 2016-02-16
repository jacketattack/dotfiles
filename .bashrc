export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export VM_DEVELOP=true
export LESS=-RFX
export ENV=local

alias ll='ls -alF'
alias l='ls -CF'

# tmux
alias tm='cd ~/tmux-profile && ruby ./load-tmux-profile.rb dev'

alias dev='cd ~/US'

# VM
# alias vbr='sudo /Library/StartupItems/VirtualBox/VirtualBox restart'

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# git
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

alias ga="git add"
alias gaa="git add ."
alias gaaa="git add -A"
alias gcm="git commit -m"
alias gp="git push"
alias gdm="git branch --merged | grep -v '\*' | xargs -n 1 git branch -d"
alias gc="git clone"
alias gs="git status"
alias gd="git diff"

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

PS1="\[\e[0;35m\]\u\[\e[0;0m\] \w\[\e[0;34m\]\$(parse_git_branch)\[\e[0;0m\]: "

# My stuff
alias cl="clear"
alias o="open"
alias al="vim ~/.bashrc"
alias v="vim ~/.vimrc"

# GO
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/Code/go/

# Eclim
alias startEclim="/opt/homebrew-cask/Caskroom/eclipse-java/4.5.1/Eclipse.app/Contents/Eclipse/eclimd"

# Homebrew API requests
export HOMEBREW_GITHUB_API_TOKEN="643e36bd52a7b4e4f26bc416efbf784dd8ebb358"

# Vagrant
alias vu="vagrant up"
alias vsh="vagrant ssh"
alias vp="vagrant provision"
alias vr="vagrant reload"
alias vs="vagrant status"
