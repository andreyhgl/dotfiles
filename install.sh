#!/bin/bash -l

set -euo pipefail

# -----------------------------------------------------------------------------
# Assess which shell is running: bash or zsh
# Symlink scripts to $HOME/.local/bin/
# Symlink configs to $HOME/{.tmux.conf,.Rprofile}
# Append source-block to rc-file (.bashrc / .zshrc)
# Setup local variables $HOME/dotfiles.local (not git tracked)
# -----------------------------------------------------------------------------


# get dir where install.sh is launched
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo " > Installing dotfiles from: $DOTFILES_DIR"


# ---- Create symlinks for custom script from ~/.local/bin --------------------

mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES_DIR/bin/checksum_verify.sh" "$HOME/.local/bin/checksum_verify.sh"
chmod +x "$DOTFILES_DIR/bin/checksum_verify.sh"
echo " > Linked checksum_verify.sh into ~/.local/bin"


# ---- Create symlinks for config files ---------------------------------------

link_dotfile() {
    local src="$1" dest="$2"
 
    if [ ! -e "$src" ]; then
        echo " > Skipping $(basename "$dest"): source '$src' missing" >&2
        return
    fi
 
    # If dest exists and is NOT already a symlink, back it up once.
    if [ -e "$dest" ] && [ ! -L "$dest" ] && [ ! -e "$dest.backup" ]; then
        mv "$dest" "$dest.backup"
        echo " > Backed up existing $(basename "$dest") to $(basename "$dest").backup"
    fi
 
    ln -sf "$src" "$dest"
    echo " > Linked $(basename "$dest")"
}
 
link_dotfile "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
link_dotfile "$DOTFILES_DIR/Rprofile" "$HOME/.Rprofile"


# ---- neovim config ----------------------------------------------------------

# symlink nvim/ to ~/.config/nvim
mkdir -p "$HOME/.config"
link_dotfile "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"


# ---- Append the source-block to shell rc-files (idempotent) -----------------

# Source-block
MARKER_BEGIN="# >>> dotfiles >>>"
MARKER_END="# <<< dotfiles <<<"
SOURCE_LINE="[ -f \"$DOTFILES_DIR/shell/bashrc.sh\" ] && source \"$DOTFILES_DIR/shell/bashrc.sh\""

# Function for append the dotfiles source-block to a single rc file 
# (if it exists)
# Usage: install_block .bashrc / .zshrc
install_block() {
    local rc="$1"
 
    # Only touch rc-files that already exist — don't create new ones.
    if [ ! -f "$rc" ]; then
        return
    fi
 
    # Back up the original
    if [ ! -f "$rc.backup" ]; then
        cp "$rc" "$rc.backup"
        echo " > Backed up $(basename "$rc") to $(basename "$rc").backup"
    fi
 
    # Idempotent: skip source-block if already present, else add it
    if grep -qF "$MARKER_BEGIN" "$rc"; then
        echo " > Dotfiles source-block already present in $(basename "$rc"), skipping..."
    else
        {
            echo ""
            echo "$MARKER_BEGIN"
            echo "$SOURCE_LINE"
            echo "$MARKER_END"
        } >> "$rc"
        echo " > Added dotfiles source-block to $(basename "$rc")"
    fi
}

# Check rc-files, only bash and zsh. Append source-block
found_rc=0
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ]; then
        install_block "$rc"
        found_rc=1
    fi
done

# If no rc-file exists, create .bashrc
if [ "$found_rc" -eq 0 ]; then
    echo " > No .bashrc or .zshrc found — creating ~/.bashrc with the source-block"
    {
        echo "$MARKER_BEGIN"
        echo "$SOURCE_LINE"
        echo "$MARKER_END"
    } > "$HOME/.bashrc"
fi


# ---- Setup local variables --------------------------------------------------

if [ ! -f "$HOME/.dotfiles.local" ]; then
    if [ -f "$DOTFILES_DIR/dotfiles.local.template" ]; then
        cp "$DOTFILES_DIR/dotfiles.local.template" "$HOME/.dotfiles.local"
        printf ' > Created %s from template. EDIT IT to set variables:\n\t - ACCOUNT\n\t - PROJECT\n' "$HOME/.dotfiles.local"
    fi
else
    echo " > ~/.dotfiles.local already exists, skipping..."
fi

echo ""
echo "------------------------------------------------------"
echo " > Done! Next steps:"
echo "  1. Edit variabiles in ~/.dotfiles.local"
echo "  2. source ~/.bashrc or ~/.zshrc"
echo "------------------------------------------------------"