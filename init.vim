" This configuration assumes neovim >= 0.6 but will also work (with some
" limitations) with classical vim.


" Pre-Plugin Settings
""""""""""""""""""""""

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
" NOTE: This has to be done before calling plug as otherwise it will overwrite
" file-type specific actions (e.g. in gitcommit.vim)
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif


" Plugins
""""""""""

if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    call plug#begin('~/.vim-plugged')
endif

"Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-fugitive'
"Plug 'vhdirk/vim-cmake', { 'on': ['CMake', 'CMakeClean', 'CMakeFindBuildDir'] }
"Plug 'vim-latex/vim-latex'
Plug 'lervag/vimtex', {'tag': 'v2.9'}
"Plug 'vim-scripts/a.vim'
Plug 'machakann/vim-sandwich'
Plug 'google/vim-searchindex'
Plug 'mileszs/ack.vim'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'vimwiki/vimwiki'
Plug 'singularityware/singularity.lang', {'rtp': 'vim/'}
Plug 'gu-fan/riv.vim', {'for': 'rst'}
Plug 'editorconfig/editorconfig-vim'
Plug 'Vimjas/vim-python-pep8-indent'

if has('nvim')
    Plug 'neovim/nvim-lspconfig'

    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/nvim-cmp'

    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'rafamadriz/friendly-snippets'

    "Plug 'ishan9299/nvim-solarized-lua'
    Plug 'luator/nvim-solarized-lua'

    Plug 'famiu/feline.nvim', { 'tag': 'v0.4.3' }
    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'lewis6991/gitsigns.nvim'

    Plug 'ray-x/lsp_signature.nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'

    Plug 'folke/which-key.nvim'
else
    Plug 'tpope/vim-sensible'
    Plug 'lifepillar/vim-solarized8'
    Plug 'rhysd/vim-clang-format'
    Plug 'psf/black', { 'on': 'Black' }
endif

call plug#end()
" vim-plug commands:
" PlugInstall [name ...] [#threads] Install plugins
" PlugUpdate [name ...] [#threads]  Install or update plugins
" PlugClean[!]  Remove unlisted plugins (bang version will clean without prompt)
" PlugUpgrade   Upgrade vim-plug itself
" PlugStatus    Check the status of plugins
" PlugDiff  Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path] Generate script for restoring the current snapshot of the plugins


" General Settings
"""""""""""""""""""

set backup  " keep a backup file

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set linebreak
set showbreak=…
set textwidth=80
"set colorcolumn=80,120

" Visualize the line were tw will break (http://superuser.com/a/207548/226624)
set colorcolumn=+0

" Always show the signcolumn to have a more stable UI
silent! set signcolumn=yes:1

" enable hybrid relative line numbers
set number
set relativenumber

" Visualize tabs and trailing spaces.
set list
set listchars=tab:⇥\ ,trail:·

" Bash-like tab completion (http://stackoverflow.com/questions/526858)
"  1st tab: complete as much as possible
"  2nd tab: show list
"  3rd tab: start cycling through the list
set wildmode=longest,list,full
set wildmenu

" detect file changes (sometimes)  https://github.com/neovim/neovim/issues/1936
set autoread
au FocusGained * :checktime

" set the timeout for CursorHold (the default is pretty long)
set updatetime=1000

" Look for ctags file in current directory and climb up to root if not found
set tags=./tags;/

" Enable spell check and set language to british english.
set spell
set spelllang=en_gb


" set colorscheme
set background=dark
set termguicolors
if has('nvim')
    " this is lua-based so only works for nvim
    colorscheme solarized

    " some customisation of the colorscheme
    highlight! link TSPunctBracket Normal
    highlight! link TSPunctDelimiter Normal
else
    colorscheme solarized8
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Enable section folding in markdown
let g:markdown_folding=1


" Key Bindings
"""""""""""""""

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Normal movement in wrapped lines (http://vim.wikia.com/wiki/VimTip308)
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up> <C-o>gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk
nnoremap <silent> j gj
nnoremap <silent> k gk

noremap <F3> :cn<CR>
noremap <F4> :lne<CR>

" fzf key-bindings
noremap <C-p> :Files<CR>
noremap <A-p> :Buffers<CR>

" Kill ex mode. Instead use Q to execute macro 'q'
" Inspired by https://news.ycombinator.com/item?id=8340181
nnoremap Q @q


" User-defined Commands
""""""""""""""""""""""""


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

" insert current date
"command Date put =strftime('%F')
" This is a bit complicated but inserts date after cursor position without
" adding new line.
command Date execute "normal a<C-R>=strftime('%F')<CR><ESC>"
command DateTime execute "normal a<C-R>=strftime('%F %H:%M')<CR><ESC>"

" Remove trailing spaces
command Detrail %s/ \+$//

" Make current file executable
command ChmodAX !chmod a+x %

" close file in current buffer and show previous buffer instead
command Bc bp | bd#



" file type mappings
"""""""""""""""""""""

" ROS launch files are xml
au BufNewFile,BufRead *.launch set filetype=xml


" Plugin Configuration
""""""""""""""""""""""

""" Latex

"imap <C-space> <Plug>IMAP_JumpForward
"nmap <C-space> <Plug>IMAP_JumpForward

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


""" NERD Commenter
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'


""" CtrlP
"let g:ctrlp_custom_ignore = '\v(\.pyc|\~|build)$'  " ignore *.pyc files
"let g:ctrlp_working_path_mode = 'wra'

""" fzf
" in vim use ag as search command which by default already excludes a lot of
" undesired files
let $FZF_DEFAULT_COMMAND = 'ag -g ""'


""" Riv (reST plugin)
let g:riv_disable_folding = 1


""" Ack
" use ag instead of ack
let g:ackprg = 'ag --vimgrep'


""" vimwiki
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown'}

" This will make sure vimwiki will only set the filetype of markdown files
" inside a wiki directory, rather than globally.
let g:vimwiki_global_ext = 0

" enable folding
let g:vimwiki_folding = 'expr'


""" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


""" vsnip
let g:vsnip_snippet_dir = fnamemodify(expand("$MYVIMRC"), ":p:h") . '/vsnip'


if has('nvim')
    " Neovim-specific configuration
    """""""""""""""""""""""""""""""

    " Highlight yanked text for a brief moment
    au TextYankPost * silent! lua vim.highlight.on_yank()

    " https://github.com/neovim/neovim/issues/5990
    let $VTE_VERSION="100"

    " lspconfig  (see :help lsp)
    lua require('lsp_config')

    lua require('treesitter')
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set foldlevel=99  " mostly disable fold by default

    lua require('gitsigns').setup()

    lua require('feline_statusline')

    lua require('which-key').setup()

    """ nvim-cmp
    set completeopt=menu,menuone,noselect
    lua require('cmp_config')
else
    " Vim-specific configuration
    """"""""""""""""""""""""""""

    "" The settings below are already default in neovim

    " allow unsaved buffers to be hidden.
    set hidden
    " Make Y behave like C and D (yank from cursor to end of line)
    nnoremap Y y$
endif
