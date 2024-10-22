# git aliases
alias gs='git status --short'
alias ga='git add'
alias gd='git diff'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'

alias gl="git log --graph --pretty=format:'%C(auto)%h %C(cyan)(%cr)%Creset%C(auto)%d%Creset %s'"

alias gb='git branch --format="%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:magenta)(%(committerdate:relative))" --sort=-committerdate'

#alias gb='git branch --format="%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:blue)(%(committerdate:relative)) [%(authorname)]" --sort=-committerdate'

# make the prompt fancy:
# + add git branch
# + works on ~/.zshrc
parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (\1)/g'
}

setopt PROMPT_SUBST
PROMPT='%9c%F{cyan}$(parse_git_branch)%f $ '
