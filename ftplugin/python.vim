set textwidth=79
" No automatic line break in code (as this breaks the syntax way too often),
" but keep it for comments.
set formatoptions-=t

" show line numbers
set number

" set PEP8-compliant formatting options (see global ftplugin/python.vim)
let g:python_recommended_style = 1

" enable all Python syntax highlighting features (see global syntax/python.vim)
let python_highlight_all = 1

" insert breakpoint with \b
map <silent> <leader>b oimport ipdb; ipdb.set_trace()  # XXX Breakpoint<esc>
map <silent> <leader>B Oimport ipdb; ipdb.set_trace()  # XXX Breakpoint<esc>
