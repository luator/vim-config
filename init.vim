" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup          " keep a backup file
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
              \ | wincmd p | diffthis
endif



""""""""""""""""""""
" My own config :) "
""""""""""""""""""""

" General Settings
"""""""""""""""""""
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

" Visualize tabs and trailing spaces.
set list
set listchars=tab:⇥\ ,trail:·

" allow unsaved buffers to be hidden.
set hidden

" Bash-like tab completion (http://stackoverflow.com/questions/526858)
"  1st tab: complete as much as possible
"  2nd tab: show list
"  3rd tab: start cycling through the list
set wildmode=longest,list,full
set wildmenu

" Customize status line
" [buffernumber] [modified] filename [filetype]              line,col    pos
set statusline=[%n]\ %m%<%.99f\ %h%w%r%y%=%-16(\ %l,%c%V\ %)%P


" detect file changes (sometimes)  https://github.com/neovim/neovim/issues/1936
set autoread
au FocusGained * :checktime

" set colorscheme
set background=dark
"se t_Co=16 " Fix for solarized (http://stackoverflow.com/a/5561823/2095383)
colorscheme solarized


" Specific gVim settings
"""""""""""""""""""""""""

if has('gui_running')
  " always show tab bar (workaround for the status-line disappears on maximized
  " window bug, https://unix.stackexchange.com/a/31317/108576).
  set showtabline=2

  " Set font for gvim
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 10

  set grepprg=grep\ -nH\ $*

  colorscheme solarized
  set background=light

  set number  " show line numbers
endif



" Key Bindings
"""""""""""""""

" Make Y behave like C and D (yank from cursor to end of line)
nnoremap Y y$

" Normal movement in wrapped lines (http://vim.wikia.com/wiki/VimTip308)
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up> <C-o>gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk
nnoremap <silent> j gj
nnoremap <silent> k gk

" Remap omnicomplete to Ctrl+Space
" (http://stackoverflow.com/a/12344382/2095383)
"inoremap <C-Space> <C-x><C-o>
"inoremap <C-@> <C-Space>

noremap <F3> :cn<CR>
noremap <F4> :lne<CR>

" Use <M-]> to go back from tags jump <C-]>.  This is a bit more intuitive and
" avoids collision with C-t in ONI.
" NOTE: My preferred remapping would be <C-[> but this is equivalent to ESC!
nnoremap <M-]> <C-t>

" Use Ctrl Alt P to open CtrlPBuffer
noremap <C-A-p> :CtrlPBuffer<CR>

" Kill ex mode. Instead use Q to execute macro 'q'
" Inspired by https://news.ycombinator.com/item?id=8340181
nnoremap Q @q


" User-defined Commands
""""""""""""""""""""""""

" insert current date
"command Date put =strftime('%F')
" This is a bit complicated but inserts date after cursor position without
" adding new line.
command Date execute "normal a<C-R>=strftime('%F')<CR><ESC>"

" Remove trailing spaces
command Detrail %s/ \+$//

command ChmodAX !chmod a+x %

" close file in current buffer and show previous buffer instead
command Bc bp | bd#

"cnoreabbrev # b#  " unfortunately causes


" file type mappings
"""""""""""""""""""""

" ROS launch files are xml
au BufNewFile,BufRead *.launch set filetype=xml


" Misc
"""""""

" Look for ctags file in current directory and climb up to root if not found
set tags=./tags;/

" Enable spell check and set language to british english.
set spell
set spelllang=en_gb


" Integrate clang-format
" http://clang.llvm.org/docs/ClangFormat.html#vim-integration
" Disabled in favor of clang-format plugin (see below)
" :command ClangFormat :pyf /usr/share/vim/addons/syntax/clang-format.py


" Plugins
""""""""""

call plug#begin(stdpath('data') . '/plugged')

Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-fugitive'
Plug 'hynek/vim-python-pep8-indent'
"Plug 'vim-syntastic/syntastic'
Plug 'vhdirk/vim-cmake'
"Plug 'taketwo/vim-ros'
"Plug 'vim-voom/VOoM'
Plug 'vim-latex/vim-latex'
Plug 'rhysd/vim-clang-format'
Plug 'psf/black', { 'on': 'Black' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/a.vim'
Plug 'machakann/vim-sandwich'
Plug 'google/vim-searchindex'
Plug 'mileszs/ack.vim'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'dense-analysis/ale'
Plug 'vimwiki/vimwiki'
Plug 'singularityware/singularity.lang', {'rtp': 'vim/'}
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'neovim/nvim-lspconfig'
Plug 'Rykka/riv.vim'

call plug#end()
" vim-plug commands:
" PlugInstall [name ...] [#threads] Install plugins
" PlugUpdate [name ...] [#threads]  Install or update plugins
" PlugClean[!]  Remove unlisted plugins (bang version will clean without prompt)
" PlugUpgrade   Upgrade vim-plug itself
" PlugStatus    Check the status of plugins
" PlugDiff  Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path] Generate script for restoring the current snapshot of the plugins


""" Latex

"imap <C-space> <Plug>IMAP_JumpForward
"nmap <C-space> <Plug>IMAP_JumpForward


""" NERD Commenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1


""" Syntastic

" passive mode by default (i.e. do not automatically check when saving files).
" This is to not have redundant checks with ALE
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers = ['flake8']
" to ensure flake8 checks for python 3 code:
let g:syntastic_python_flake8_exe = 'python3 -m flake8'
let g:syntastic_python_pydocstyle_args = "--match='.*'"
let g:syntastic_c_checkers = []
let g:syntastic_cpp_checkers = []
let g:syntastic_rst_checkers = ['sphinx']


""" CtrlP

let g:ctrlp_custom_ignore = '\v(\.pyc|\~|build)$'  " ignore *.pyc files
let g:ctrlp_working_path_mode = 'wra'


""" vim-ros
"let g:ros_make = 'current'  " [current|all]
"let g:ros_build_system = 'catkin-tools'  " [catkin|rosbuild|catkin-tools]
" Additional options for catkin_make (i.e '-j4 -DCMAKE_BUILD_TYPE=Debug' ...)
"let g:ros_catkin_make_options = ''


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


""" NeoVim specific
" https://github.com/neovim/neovim/issues/5990
let $VTE_VERSION="100"

" lspconfig  (see :help lsp)
:lua require('lsp_config')


""" ALE (https://github.com/w0rp/ale)
" LSPs are handled by neovim itself
let g:ale_disable_lsp = 1
" Do not run linters on every text change
let g:ale_lint_on_text_changed = 'never'

let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'
let g:ale_python_mypy_options = '--ignore-missing-imports'


""" airline
" remove 'spell' from section a
let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'keymap', 'capslock', 'xkblayout', 'iminsert'])


""" Search: mark current match in different colour
" https://vi.stackexchange.com/a/2770/3261

" Damian Conway's Die Blinkënmatchen: highlight matches
"nnoremap <silent> n n:call HLNext(0.1)<cr>
"nnoremap <silent> N N:call HLNext(0.1)<cr>
"function! HLNext (blinktime)
"  let target_pat = '\c\%#'.@/
"  let ring = matchadd('ErrorMsg', target_pat, 101)
"  redraw
"  " disable the blink part
"  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"  call matchdelete(ring)
"  redraw
"endfunction
