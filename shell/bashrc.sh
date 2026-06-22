# Dotfiles shell additions.
# This file is sourced from the system ~/.bashrc — it does NOT replace it.
# Everything here layers on top of whatever the host already set up.

# Locate the dotfiles repo based on where this file actually lives,
# so it works no matter where the repo was cloned.
# ${BASH_SOURCE[0]} works in bash; ${(%):-%x} is the zsh equivalent.
if [ -n "${BASH_SOURCE:-}" ]; then
    _dotfiles_self="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
    _dotfiles_self="${(%):-%x}"
else
    _dotfiles_self="$0"
fi
DOTFILES="$(cd "$(dirname "$_dotfiles_self")/.." && pwd)"
unset _dotfiles_self

# Put user executables on PATH (where install.sh symlinks the batch script).
export PATH="$HOME/.local/bin:$PATH"

# Load environmental variables, custom shell functions and aliases
[ -f "$DOTFILES/shell/exports.sh" ] && source "$DOTFILES/shell/exports.sh"
[ -f "$DOTFILES/shell/functions.sh" ] && source "$DOTFILES/shell/functions.sh"
[ -f "$DOTFILES/shell/aliases.sh" ] && source "$DOTFILES/shell/aliases.sh"
[ -f "$DOTFILES/shell/prompt.sh" ] && source "$DOTFILES/shell/prompt.sh"

# Machine-local overrides (untracked; holds ACCOUNT and per-cluster settings).
# Sourced LAST so it can override anything above.
[ -f "$HOME/.dotfiles.local" ] && source "$HOME/.dotfiles.local"


# ---- Print help function ----------------------------------------------------

# Will print command to see all custom functions and configs.
# Only in interactive shells
# will suppress inside tmux (annoying to see the hint for every new pane)
case $- in
    *i*)
        if [ -z "${TMUX:-}" ]; then
            printf '\n > Type \033[36mdotfiles\033[0m to list custom commands.\n\n'
        fi
        ;;
esac