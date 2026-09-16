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
alias tmdev='cd ~/tmux-profile && ruby ./load-tmux-profile.rb dev'

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
alias gpom="git pull origin master -r"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gfp="git fetch -p"
alias grh="git reset --hard"
alias diffFiles="git diff --name-only"
alias devUpdate="gfp && gpod"
alias rebaseOnDev="gch develop && gpod && gch - && git rebase develop"
alias gcp="git cherry-pick"
alias gl="git log"

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
alias pbcopy="pbcopy"

# Claude
alias resumeClaudeSession="claude --resume"

# Docker
alias dc="docker-compose"

# Maven
alias mvCheck="mvn checkstyle:checkstyle"
alias mci="mvn clean install"
alias mvnInstallNoTests="mvn clean install -Dskip.analyze=true -DskipTests=true"

export JAVA_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=512m"
export MAVEN_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=512m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044"

# Jetbrains
alias jetbrainsToolbox="open -a 'JetBrains Toolbox'"

# Telegram App
alias telegram="open -a 'Telegram'"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PickemPals
alias oddsGetSports="hurl --variables-file ~/dev/pickem-pals/docs/.env --from-entry 1 --to-entry 1 ~/dev/pickem-pals/docs/odds-api-requests.hurl"
alias oddsGetMoneylines="hurl --variables-file ~/dev/pickem-pals/docs/.env --from-entry 2 --to-entry 2 ~/dev/pickem-pals/docs/odds-api-requests.hurl"
alias oddsGetScores="hurl --variables-file ~/dev/pickem-pals/docs/.env --from-entry 3 --to-entry 3 ~/dev/pickem-pals/docs/odds-api-requests.hurl