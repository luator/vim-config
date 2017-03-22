set tabstop=8
set expandtab
set shiftwidth=2
set softtabstop=2
set tw=80
set iskeyword+=:
:setlocal spell spelllang=en_gb

" setup vim-latexsuite for gvim
if has('gui_running')
  let g:tex_flavor='latex'

  au BufEnter *.tex set autowrite
  " use pdflatex
  let g:Tex_DefaultTargetFormat = 'pdf'
  let g:Tex_MultipleCompileFormats = 'pdf'
  let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode $*'
  let g:Tex_GotoError = 0
  let g:Tex_ViewRule_pdf = 'evince'
  let g:Tex_FoldedEnvironments = 'tikzpicture,'
endif
