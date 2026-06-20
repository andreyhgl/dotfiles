# Add Git info to shell prompt, no dependencies
# Sourced by shell/bashrc.sh

# Show " (branch)" — or " (abc1234)" in detached HEAD — else nothing.
parse_git_branch() {
    local ref
    ref=$(git symbolic-ref --short HEAD 2>/dev/null) \
        || ref=$(git rev-parse --short HEAD 2>/dev/null) \
        || return
    printf ' (%s)' "$ref"
}

if [ -n "${BASH_VERSION:-}" ]; then
    # bash: \[ \] wrap non-printing color codes so line-wrap math stays correct.
    PS1='[\u@\h \W]\[\033[01;36m\]$(parse_git_branch)\[\033[00m\] \$ '
elif [ -n "${ZSH_VERSION:-}" ]; then
    # zsh: PROMPT_SUBST lets $(...) run on each prompt render.
    setopt PROMPT_SUBST
    # %n user, %m short host, %2~ last two path components, %F/%f color.
    #PROMPT='[%n@%m %2~]%F{cyan}$(parse_git_branch)%f $ '
    PROMPT='[andy@aces %2~]%F{cyan}$(parse_git_branch)%f $ '
fi