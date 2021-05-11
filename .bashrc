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
alias gch="git checkout"
alias gchb="git checkout -b"
alias gs="git status"
alias gst="git stash"
alias gd="git diff"
alias gau="git add -u"
alias gpod="git pull origin develop -r"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gfp="git fetch -p"
alias diffFiles="git diff --name-only"
alias devUpdate="gfp && gpod"
alias rebaseOnDev="gch develop && gpod && gch - && git rebase develop"
alias gcp="git cherry-pick"

# need to fix this alias gpor="git pull origin $(git branch | grep -E '^\* ' | sed 's/^\* //g') --rebase"
git() { if [[ $@ == *"pull"* && $@ != *" -r"*  ]]; then command echo "Don’t be an idiot."; else command git "$@"; fi;  }

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
alias wego="go run ~/Code/go/src/github.com/schachmat/wego/we.go"
alias zork="cd ~/Code/zork/ && ./zork"
alias word="vim ~/wordOfTheDay"
alias whatsrunning="lsof -i"
alias food="foodcritic -f all"
alias gr="grep -r"
alias pip="pip3"
alias py="python3"
alias be="bundle exec"
alias thedr="sudo java -jar ~/.drjava/drjava.jar &"
alias dzip="~/.dzip/./dzip"

# GO
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOROOT=/usr/local/Cellar/go/1.5.3/libexec
#export GOPATH=$HOME/US/evt/Product/gocomponents
export GOPATH=$HOME/Code/go
# Eclim
alias startEclim="/opt/homebrew-cask/Caskroom/eclipse-java/4.5.1/Eclipse.app/Contents/Eclipse/eclimd"

# Vagrant
alias vu="vagrant up"
alias vsh="vagrant ssh"
alias vp="vagrant provision"
alias vr="vagrant reload"
alias vs="vagrant status"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# RVM
#source ~/.profile

# RabbitMq
PATH=$PATH:/usr/local/sbin

# PHP MAMP
export PATH=/Applications/MAMP/bin/php/php7.0.0/bin:$PATH

# Imports Testing against local VM
export RABBIT_HOST=192.168.33.11
export ENV_HOST=192.168.33.11
export MONGO_HOST=192.168.33.11
alias adminMongo="cd ~/Code/adminMongoOfficial && npm start"

# Docker
alias dc="docker-compose"

export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

# Redshift
export DYLD_LIBRARY_PATH="/opt/amazon/redshift/lib"
export AMAZONREDSHIFTODBCINI="/opt/amazon/redshift/amazon.redshiftodbc.ini"

# Maven
alias mvCheck="mvn checkstyle:checkstyle"
alias datCodeCoverage="mvn install -Dpmd.skip=true"
alias accelInstall="mvn clean install -Dskip.analyze=true -DskipTests=true"
alias runAccelerator="mvn jetty:run -Dskip.analyze=true"

export ACCELERATOR_HOME=/opt/accelerator
export GEARS_HOME="/opt/messagegears"
export JAVA_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=512m"
export MAVEN_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=512m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044"

# Use MacVim
#alias vim="/Applications/MacVim.app/Contents/MacOs/Vim"

# Generic Ops
alias 'nexus'="~/.nexus/./nexus"
