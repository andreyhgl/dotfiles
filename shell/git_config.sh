# git aliases
alias gs='git status --short'
alias ga='git add'
alias gd='git diff'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gsw='git switch'
alias gpush='git push'
alias gpull='git pull'

alias gl="git log --graph --pretty=format:'%C(auto)%h %C(cyan)(%cr)%Creset%C(auto)%d%Creset %s'"

alias gb="git branch --format='%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:magenta)(%(committerdate:relative))' --sort=-committerdate"

#alias gb='git branch --format="%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:blue)(%(committerdate:relative)) [%(authorname)]" --sort=-committerdate'