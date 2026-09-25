# Dotfiles shell additions.
# This file is sourced from the system ~/.bashrc — it does NOT replace it.
# Everything here layers on top of whatever the host already set up.

#---- Detect shell -----------------------------------------------------------

# Detect the current shell once
if [ -n "${ZSH_VERSION:-}" ]; then
    _dotfiles_shell=zsh
elif [ -n "${BASH_VERSION:-}" ]; then
    _dotfiles_shell=bash
else
    _dotfiles_shell=sh
fi


# ---- Locate dotfiles repo ---------------------------------------------------

# Locate the dotfiles repo based on where this file actually lives,
# so it works no matter where the repo was cloned.
case "$_dotfiles_shell" in
    bash) _dotfiles_self="${BASH_SOURCE[0]}" ;;
    zsh)  _dotfiles_self="${(%):-%x}" ;;
    *)    _dotfiles_self="$0" ;;
esac

DOTFILES="$(cd "$(dirname "$_dotfiles_self")/.." && pwd)"
unset _dotfiles_self


# ---- PATH -------------------------------------------------------------------

# Put user executables on PATH (where install.sh symlinks the batch script).
# Only add it once, so nested shells and tmux panes don't keep growing PATH.
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac


# ---- Modules ----------------------------------------------------------------

# Load environment variables, custom shell functions, aliases and prompt.
for _dotfiles_module in exports functions aliases prompt; do
    _dotfiles_file="$DOTFILES/shell/$_dotfiles_module.sh"
    [ -f "$_dotfiles_file" ] && . "$_dotfiles_file"
done
unset _dotfiles_module _dotfiles_file


# ---- Completion -------------------------------------------------------------

# Case-insensitive tab completion
# Keep after the modules (so any fpath changes are in place) 
# and before the local overrides (so machine-specific settings can change it).
case "$_dotfiles_shell" in
    zsh)
        autoload -Uz compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        ;;
    bash)
        case $- in
            *i*) bind "set completion-ignore-case on" ;;
        esac
        ;;
esac
unset _dotfiles_shell


# ---- Local overrides --------------------------------------------------------

# Machine-local overrides (untracked; holds ACCOUNT and per-cluster settings).
# Sourced LAST so it can override anything above.
[ -f "$HOME/.dotfiles.local" ] && . "$HOME/.dotfiles.local"


# ---- Print help hint --------------------------------------------------------

# Print a hint about the `dotfiles` command in interactive shells only.
# Suppressed inside tmux (annoying to see the hint in every new pane).
case $- in
    *i*)
        if [ -z "${TMUX:-}" ]; then
            printf '\n > Type \033[36mdotfiles\033[0m to list custom commands.\n\n'
        fi
        ;;
esac