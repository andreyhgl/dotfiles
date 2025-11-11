alias R='R --no-save --no-restore'
alias ll='ls -lhov --group-directories-first --color'
alias la='ls -alhov --group-directories-first --color'
alias jobinfo='squeue -u $USER'

export RNASEQ_SIF="library://andreyhgl/singularity-r/rnaseq"
export GO_SIF="library://andreyhgl/singularity-r/gene-ontology"
export METH_SIF="library://andreyhgl/singularity-r/methylome"