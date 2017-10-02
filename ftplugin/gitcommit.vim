if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1 " Don't load twice in one buffer

" set cursor always to first line in git commit message
call setpos('.', [0, 1, 1, 0])
" set text width to 72 for git commit messages
setlocal tw=72
" enable spellcheck
setlocal spell
