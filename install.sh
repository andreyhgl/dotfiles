#!/bin/bash

# check which shell is being used
if [ -f "${HOME}/.bashrc" ]; then
	SH=${HOME}/.bashrc
	IS_BASH=true
else
	SH="${HOME}/.zshrc"
	IS_BASH=false
fi

echo '# ~~~~~~~~~ andreys dotfiles config ~~~~~~~~~ #' >> $SH

# skip aliases.sh on zsh
SKIP_FILE="shell/aliases.sh"

for file in shell/*; do

  # Skip if this is the bash-only file and we're not using bash
  if [ "$IS_BASH" = false ] && [ "$file" = "$SKIP_FILE" ]; then
        echo "Skipping $file"
        continue
  fi

	echo "${file}"
	echo "source ${HOME}/.dotfiles/${file}" >> $SH
done

echo 'Adding symbolic link to tmux.conf'
ln -sf "${HOME}/.dotfiles/.tmux.conf" ~/.tmux.conf

echo 'Adding symbolic link to Rprofile'
ln -sf "${HOME}/.dotfiles/.Rprofile" ~/.Rprofile