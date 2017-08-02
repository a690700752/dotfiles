call plug#begin('~/.local/share/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'tomasr/molokai'
Plug 'kien/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'reedes/vim-colors-pencil'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/YankRing.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'rust-lang/rust.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
call plug#end()

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" How many space for TAB
set tabstop=4
" How many space for indent layer
set shiftwidth=4
" Expand TAB to space
set expandtab
" How many space delete when use Back Space key
set softtabstop=4
set nu
set relativenumber
colorscheme molokai
set cursorline
" set cursorcolumn
let mapleader = "\<Space>"
" Open hightlight searcg
set hlsearch 
" Searching when input string
set incsearch 
" Auto read when file edit outside
set autoread
set hidden
set noshowmode

" Limelight and Goyo.vim integration
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Config YankRing
let g:yankring_replace_n_pkey='<leader>p'

" Config deoplete
let g:deoplete#enable_at_startup = 1

" Config LanguageClient-neovim
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
let g:LanguageClient_autoStart = 1

" Config echodoc
let g:echodoc#enable_at_startup = 1

" Config rust.vim
let g:rustfmt_autosave = 1

" Key mappings
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
