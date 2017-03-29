" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler			" show the cursor position all the time
set showcmd			" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

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

  set autoindent		" always set autoindenting on

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
set shiftwidth=2
set linebreak
set showbreak=…
set expandtab
set tw=79

" Visualize the line were tw will break (http://superuser.com/a/207548/226624)
set colorcolumn=+0

" Visualize tabs and trailing spaces.
set list
set listchars=tab:\ \ ,trail:·

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

" set colorscheme
set background=dark
"se t_Co=16 " Fix for solarized (http://stackoverflow.com/a/5561823/2095383)
colorscheme solarized


" Specific gVim settings
"""""""""""""""""""""""""

if has('gui_running')
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
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" Remap omnicomplete to Ctrl+Space
" (http://stackoverflow.com/a/12344382/2095383)
"inoremap <C-Space> <C-x><C-o>
"inoremap <C-@> <C-Space>

" Press Ctrl+J to split line at cursor position
" (http://stackoverflow.com/questions/3961730/how-to-break-a-line-in-vim-in-normal-mode)
":nnoremap <NL> i<CR><ESC>

map <F3> :cn<CR>
map <F4> :lne<CR>

" Use Ctrl Alt P to open CtrlPBuffer
map <C-A-p> :CtrlPBuffer<CR>


" User-defined Commands
""""""""""""""""""""""""

" insert current date
:command Date r!date +"{\%F}"
" close file in current buffer and show previous buffer instead
:command Bc bp | bd#


" file type mappings
"""""""""""""""""""""

" ROS launch files are xml
au BufNewFile,BufRead *.launch set filetype=xml


" Misc
"""""""

" set cursor always to first line in git commit message
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" Look for ctags file in current directory and climb up to root if not found
set tags=./tags;/


" Plugins
""""""""""

filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-sensible'
Plugin 'python-rope/ropevim'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'vim-syntastic/syntastic'
Plugin 'vhdirk/vim-cmake'
Plugin 'taketwo/vim-ros'

call vundle#end()
" Brief Vundle help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line


"execute pathogen#infect()

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.  Also load indent files, to automatically
" do language-dependent indenting.
" This has to come *after* pathogen#infect/vundle
filetype plugin indent on


""" Latex

"imap <C-space> <Plug>IMAP_JumpForward
"nmap <C-space> <Plug>IMAP_JumpForward


""" NERD Tree

" Open/Close NERD Tree with C-n
map <C-n> :NERDTreeToggle<CR>


""" Syntastic

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers = ['flake8']
" to ensure flake8 checks for python 2 code (calling only 'flake8' gives the
" python 3 version):
let g:syntastic_python_flake8_exe = 'python -m flake8'
let g:syntastic_c_checkers = []
let g:syntastic_cpp_checkers = []


""" ropevim

"let ropevim_vim_completion = 1
let ropevim_enable_autoimport = 0


""" CtrlP

let g:ctrlp_custom_ignore = '\v(\.pyc|\~|build)$'  " ignore *.pyc files
