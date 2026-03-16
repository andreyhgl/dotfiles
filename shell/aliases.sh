alias R='R --no-save --no-restore'
alias ll='ls -lhov --group-directories-first --color'
alias la='ls -alhov --group-directories-first --color'
alias du='du -sh'

# Nextflow
alias nl='nextflow log'

# squeue output, %[number][flag], %.10i
# %i = Job ID, %P = Partition, %j = Job name (full), %u = User, %T = State
# %M = Time used, %l = Time limit, %D = Nodes, %R = Reason/Nodelist
alias jobinfo_full='squeue -u $USER -o "%T %M %R %D %P %.10i %j %.l" | column -t | less -S'
alias jobinfo='squeue -u $USER'

export RNASEQ_SIF="library://andreyhgl/singularity-r/rnaseq"
export GO_SIF="library://andreyhgl/singularity-r/gene-ontology"
export METH_SIF="library://andreyhgl/singularity-r/methylome"
export EDGER_SIF="library://andreyhgl/r/edger"