execute pathogen#infect()
syntax on
set number
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
colorscheme desert 
set backspace=indent,eol,start

" Open NERDTree if no given file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

