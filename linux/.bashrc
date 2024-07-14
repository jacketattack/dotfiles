export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export VM_DEVELOP=true
export LESS=-RFX
export ENV=local

alias ll='ls -alF'
alias l='ls -CF'
alias la='ls -a'

# tmux
alias tm='cd ~/tmux-profile && ruby ./load-tmux-profile.rb dev'

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
alias whatsrunning="lsof -i"
alias gr="grep -r"
alias pip="pip3"
alias py="python3"
alias be="bundle exec"

# Docker
alias dc="docker-compose"

# Maven
alias mvCheck="mvn checkstyle:checkstyle"
alias mvnInstallNoTests="mvn clean install -Dskip.analyze=true -DskipTests=true"

export JAVA_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=512m"
export MAVEN_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=512m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044"
