#!/bin/bash

# check which shell is being used
if [ -f "${HOME}/.bashrc" ]; then
	SH=${HOME}/.bashrc
else
	SH="${HOME}/.zshrc"
fi

echo '# ~~~~~~~~~ andreys dotfiles config ~~~~~~~~~ #' >> $SH

for file in shell/*; do
	echo "${file}"
	echo "source ${HOME}/.dotfiles/${file}" >> $SH
done

echo 'Adding symbolic link to tmux.conf'
ln -sf "${HOME}/.dotfiles/.tmux.conf" ~/.tmux.conf

echo 'Adding symbolic link to Rprofile'
ln -sf "${HOME}/.dotfiles/.Rprofile" ~/.Rprofile