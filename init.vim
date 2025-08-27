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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdcommenter', {'tag': '2.7.0'}
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive', {'tag': 'v3.7'}
Plug 'lervag/vimtex', {'tag': 'v2.15'}
Plug 'machakann/vim-sandwich'
Plug 'mileszs/ack.vim'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'jlanzarotta/bufexplorer', {'tag': '7.11.0'}

Plug 'vimwiki/vimwiki', {'tag': 'v2024.01.24'}
Plug 'michal-h21/vim-zettel'
"Plug 'tools-life/taskwiki'

Plug 'singularityware/singularity.lang', {'rtp': 'vim/'}
Plug 'Vimjas/vim-python-pep8-indent'

Plug 'junegunn/goyo.vim'
Plug 'szw/vim-maximizer'

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
    "Plug 'tobi-wan-kenobi/zengarden'
    Plug 'luator/zengarden', {'branch': 'luator'}  " my customised version
    Plug 'rktjmp/lush.nvim'

    Plug 'famiu/feline.nvim', {'tag': 'v1.1.3'}
    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'lewis6991/gitsigns.nvim', {'tag': 'v1.0.2'}
    Plug 'kdheepak/lazygit.nvim'

    Plug 'ray-x/lsp_signature.nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/nvim-treesitter-context'
    Plug 'nvim-treesitter/playground'

    " for better folding
    Plug 'kevinhwang91/promise-async', {'tag': 'v1.0.0'} " needed by nvim-ufo
    Plug 'kevinhwang91/nvim-ufo', {'tag': 'v1.5.0'}

    Plug 'folke/which-key.nvim', {'tag': 'v3.17.0'}

    Plug 'stevearc/aerial.nvim', {'tag': 'v2.5.0'}

    Plug 'zbirenbaum/copilot.lua' ", { 'on': 'Copilot' }
    Plug 'zbirenbaum/copilot-cmp'
    Plug 'CopilotC-Nvim/CopilotChat.nvim', {'tag': 'v3.10.1'}
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
set textwidth=88
"set colorcolumn=80,120
set breakindent

" Visualize the line were tw will break (http://superuser.com/a/207548/226624)
set colorcolumn=+0

" Always show the signcolumn to have a more stable UI
silent! set signcolumn=yes:1

" enable line numbers
set number
"set relativenumber

" Visualize tabs and trailing spaces.
set list
set listchars=tab:⇥\ ,trail:·

" border around all floating windows (like lsp hover)
set winborder=rounded

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

" Add two spaces between sentences when joining lines.
set joinspaces


" set colorscheme
"set background=dark
set background=light
set termguicolors
if has('nvim')
    " this is lua-based so only works for nvim
    "colorscheme solarized

    lua require("zengarden").setup({ italics = false })
    colorscheme zengarden
else
    colorscheme solarized8
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Enable section folding in markdown
let g:markdown_folding=1


" Custom digraphs
digraphs SS 7838  " upper-case ß


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

" swap p and P in visual mode (P keeps the old value in the clipboard, which I
" want to be the default).
vnoremap p P
vnoremap P p

" create file under cursor (https://stackoverflow.com/a/6159415)
noremap <leader>gf :e <cfile><cr>

noremap <F3> :cn<CR>
noremap <F4> :lne<CR>

" fzf key-bindings
noremap <C-p> :Files<CR>
noremap <A-p> :Buffers<CR>

" Kill ex mode. Instead use Q to execute macro 'q'
" Inspired by https://news.ycombinator.com/item?id=8340181
nnoremap Q @q

" https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
nnoremap cn *``cgn
nnoremap cN *``cgN

" call the lazygit plugin
nnoremap <silent> <leader>lg :LazyGit<CR>

" evaluate selection with lua (could also use `eval` for vimscript or py3eval
" for Python)
xnoremap <Leader>e c<C-R>=luaeval(@")<CR><Esc>


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

" git commit in new tab (so the full window is used)
command Commit tab Git commit -v

" basic title case conversion of the current line
" capitalises first and last word and all with 4 or more characters
" https://www.reddit.com/r/vim/comments/dsuiqz/comment/f6rq63f/?utm_source=share&utm_medium=web2x&context=3
command TitleCase s/\<\w\{4,}\|^\w\+\|\w\+$\>/\=toupper(submatch(0)[0]).submatch(0)[1:]/g



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
let $FZF_DEFAULT_COMMAND = 'ag --hidden -g ""'


""" Riv (reST plugin)
let g:riv_disable_folding = 1


""" Ack
" use ag instead of ack
let g:ackprg = 'ag --vimgrep --hidden'


""" vimwiki
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md', 'auto-tags': 1, 'custom_wiki2html': '~/.config/nvim/bin/vimwiki2html.sh', 'diary_frequency': 'yearly'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown'}

" This will make sure vimwiki will only set the filetype of markdown files
" inside a wiki directory, rather than globally.
let g:vimwiki_global_ext = 0

" enable folding
let g:vimwiki_folding = 'expr'

if has('nvim')
    lua require('find_vimwiki')
endif

" fuzzy-find files in the main vimwiki folder
nmap <Leader>wo :Files ~/vimwiki/<return>

""" vim-zettel
let g:zettel_fzf_command = "ag --column -o '(?<=^title:).*' *.md"
nmap <leader>zo :ZettelOpen<return>
nmap <leader>zs :ZettelSearch<return>
nmap <leader>zn :ZettelNew


""" vsnip
let g:vsnip_snippet_dir = fnamemodify(expand("$MYVIMRC"), ":p:h") . '/vsnip'


""" goyo

let g:goyo_width = 88
let g:goyo_height = 90

function! s:goyo_enter()
    lua require('gitsigns').detach()
endfunction

function! s:goyo_leave()
    lua require('gitsigns').attach()
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


""" vim-maximizer
let g:maximizer_default_mapping_key = '<F5>'


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
    hi! link TreesitterContext ColorColumn
    hi TreesitterContextBottom gui=underline guisp=Grey
    hi TreesitterContextLineNumberBottom gui=underline guisp=Grey

    lua require('folding')
    set fillchars+=foldopen:,foldsep:│,foldclose:

    lua require('gitsigns_config')

    lua require('feline_statusline')

    lua require('config_aerial')

    lua require('which-key').setup()

    lua require("copilot_config")

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
