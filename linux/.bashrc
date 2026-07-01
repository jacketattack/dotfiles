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
alias diffFiles="git diff --name-only"
alias devUpdate="gfp && gpod"
alias rebaseOnDev="gch develop && gpod && gch - && git rebase develop"
alias rebaseOnMaster="gch master && gpom && gch - && git rebase master"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
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
alias pbcopy="xclip -selection clipboard"

# Docker
alias dc="docker-compose"

# Maven
alias mvCheck="mvn checkstyle:checkstyle"
alias mvnInstallNoTests="mvn clean install -Dskip.analyze=true -DskipTests=true"

export JAVA_OPTS="-Xmx2048m -Xms2048m"
export MAVEN_OPTS="-Xmx2048m -Xms2048m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044"

# Dev Tools
export PATH="$HOME/.intellij/bin:$PATH"
alias intellij="idea.sh > /dev/null 2>&1 &"
alias cursor="~/.cursorapp/./cursor1.0.AppImage > /dev/null 2>&1 &"
alias ctrlFix="setxkbmap -option ctrl:nocaps,caps:ctrl_modifier"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"

# Claw
alias telegram="~/.telegram/./Telegram > /dev/null 2>&1 &"

# pnpm
export PNPM_HOME="/home/trevor/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
