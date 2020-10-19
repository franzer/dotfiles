call plug#begin('~/.local/share/nvim/plugged')

Plug 'davidhalter/jedi-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
Plug 'neomake/neomake'

call plug#end()

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
colorscheme onedark
let g:neomake_python_enabled_makers = ['flake8']
" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
let g:deoplete#enable_at_startup = 1
set number
