syntax on
set number

set autoindent 
set noexpandtab 
set tabstop=2
set shiftwidth=2

set pastetoggle=<F2>

call plug#begin('~/.vim/plugged')

Plug 'nextflow-io/vim-language-nextflow' 

call plug#end()