# Shell aliases
# Sourced from shell/aliases.sh


# ---- git --------------------------------------------------------------------

alias gs='git status --short'
alias ga='git add'
alias gd='git diff'
alias gds='git diff --staged'

# gc: commit with a message, no quotes needed.
# Usage: gc fix the parser bug
# "$*" joins all args into one string so the whole thing becomes the message.
# Add quotes if using special characters: > \ ' etc
gc() {
	git commit -m "$*"
}

alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gsw='git switch'
alias gp='git push'
alias gpl='git pull'

alias gl="git log --graph --pretty=format:'%C(auto)%h %C(cyan)(%cr)%Creset%C(auto)%d%Creset %s'"

alias gt="git for-each-ref --sort=-creatordate --format='%(color:yellow)%(refname:short)%(color:reset) %(color:cyan)(%(creatordate:relative))%(color:reset) %(color:green)%(taggername)%(color:reset) %(contents:subject)' refs/tags"

alias gb="git branch -a --format='%(HEAD) %(color:cyan)%(refname:short)%(color:reset) - %(contents:subject) %(color:magenta)(%(committerdate:relative))' --sort=-committerdate --sort=refname"


# ---- R ----------------------------------------------------------------------

alias R='R --no-save --no-restore'


# --- Slurm -------------------------------------------------------------------

alias jobinfo='squeue -u $USER'
 
# less -FRXS: quit-if-fits, no-wrap, keep
# squeue output: %[number][flag] = %.10i
# Fields:
# %i = Job ID, %P = Partition, %j = Job name (full), %u = User, %T = State
# %M = Time used, %l = Time limit, %D = Nodes, %R = Reason/Nodelist
alias jobinfo_full='squeue -u $USER -o "%T %M %R %D %P %.10i %j %.l" | column -t | less -FRXS'

alias ll='ls -lhov --group-directories-first --color'
alias lt='ls -lhovtr --group-directories-first --color'
alias la='ls -alhov --group-directories-first --color'
alias du='du -sh'


# ---- Nextflow ---------------------------------------------------------------

alias "nflog"='nextflow log last -f status,hash,complete,name | less -FRXS'