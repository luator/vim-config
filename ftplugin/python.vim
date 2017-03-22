set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set textwidth=79

" show line numbers
set number

" enable all Python syntax highlighting features
let python_highlight_all = 1

" insert breakpoint with \b
map <silent> <leader>b oimport ipdb; ipdb.set_trace()  # XXX Breakpoint<esc>
map <silent> <leader>B Oimport ipdb; ipdb.set_trace()  # XXX Breakpoint<esc>
