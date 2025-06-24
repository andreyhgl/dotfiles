parse_git_branch() {
  git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (\1)/g'
}

# works with .bashrc
if [ -f "${HOME}/.bashrc" ]; then
  PS1="[\u@\h \W]\[\033[01;36m\]\$(parse_git_branch)\[\033[00m\]$ "
else
# works with .zshrc
#if [ -f "${HOME}/.zshrc" ]; then
  setopt PROMPT_SUBST
  PROMPT='%2~%F{cyan}$(parse_git_branch)%f $ '
fi