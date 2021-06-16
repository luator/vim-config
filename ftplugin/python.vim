set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set textwidth=79
" No automatic line break in code (as this breaks the syntax way too often),
" but keep it for comments.
set formatoptions-=t
" set comment leader for Python
set comments=b:#

" show line numbers
set number

" enable all Python syntax highlighting features
let python_highlight_all = 1

" insert breakpoint with \b
map <silent> <leader>b oimport ipdb; ipdb.set_trace()  # XXX Breakpoint<esc>
map <silent> <leader>B Oimport ipdb; ipdb.set_trace()  # XXX Breakpoint<esc>
