set nocompatible

call pathogen#infect()

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set incsearch "find the next match as we type the search
set hlsearch "hilight searches by default

syntax on
set number
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
colorscheme monokai
"colorscheme lucario
set backspace=indent,eol,start

" For test262
au BufNewFile,BufRead *.template set ft=javascript
au BufNewFile,BufRead *.case set ft=javascript

" Open NERDTree if no given file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"default indent settings
set shiftwidth=2
set softtabstop=2
set expandtab "use spaces instead of tabs
set autoindent

" some stuff to get the mouse going in term
"set mouse=a
"set ttymouse=xterm2
" who needs mouse on vim?

"tell the term has 256 colors
set t_Co=256

"hide buffers when not displayed
set hidden

set wrap "dont wrap lines
set linebreak "wrap lines at convenient points
if v:version >= 703
	"undo settings
	set undodir=~/.vim/undofiles
	set undofile
	set colorcolumn=+1 "mark the ideal max text width
endif
