# git aliases
alias gs='git status --short'
alias ga='git add'
alias gd='git diff'
alias gds='git diff --staged'
gc() {
	# usage: gc commit message ...
	# no quotes needed
	git commit -m "$*"
}

alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gsw='git switch'
alias gp='git push'

gpl() {
  if [ -n "$1" ]; then
    git -C "$1" pull
  else
    git pull
  fi
}

alias gl="git log --graph --pretty=format:'%C(auto)%h %C(cyan)(%cr)%Creset%C(auto)%d%Creset %s'"

alias gt="git for-each-ref --sort=-creatordate --format='%(color:yellow)%(refname:short)%(color:reset) %(color:cyan)(%(creatordate:relative))%(color:reset) %(color:green)%(taggername)%(color:reset) %(contents:subject)' refs/tags"

gb() {
  if [ $# -gt 0 ]; then
    git branch "$@"
  else
    git branch -a \
      --format='%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:magenta)(%(committerdate:relative))' \
      --sort=-committerdate
  fi
}

#alias gb="git branch -a --format='%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:magenta)(%(committerdate:relative))' --sort=-committerdate --sort=refname"