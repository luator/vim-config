" http://www.vim.org/scripts/script.php?script_id=1494
" (modified a bit)

" Only do this when not done yet for this buffer
"if exists("b:did_ftplugin")
"	finish
"endif
let b:did_ftplugin = 1

setlocal foldmethod=expr
setlocal foldexpr=PythonFoldExpr(v:lnum)
setlocal foldtext=PythonFoldText()

let b:folded = 1

function! ToggleFold()
    if( b:folded == 0 )
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! PythonFoldText()

    let size = 1 + v:foldend - v:foldstart
    if size < 10
        let size = " " . size
    endif
    if size < 100
        let size = " " . size
    endif
    if size < 1000
        let size = " " . size
    endif

    let lineno = v:foldstart
    let text = ""

    while text == "" || text == "'''" || text == '"""'
        let text = substitute(getline(lineno), '\v^\s*(.{-})\s*$', '\1', '')
        let lineno = lineno + 1
    endif

    if match(text, '"""') >= 0
        let text = substitute(text, '"""', '', 'g' )
    elseif match(text, "'''") >= 0
        let text = substitute(text, "'''", '', 'g' )
    endif

    return '[' . size . '] ' . text . '  '

endfunction

function! PythonFoldExpr(lnum)

    if indent( nextnonblank(a:lnum) ) == 0
        return 0
    endif

    if getline(a:lnum-1) =~ '\v^[ ]*(class|def)\s'
        return 1
    endif

    if getline(a:lnum) =~ '^\s*$'
        return '='
    endif

    if indent(a:lnum) == 0
        return 0
    endif

    return '='

endfunction

" In case folding breaks down
function! ReFold()
    set foldmethod=expr
    set foldexpr=0
    set foldnestmax=1
    set foldmethod=expr
    set foldexpr=PythonFoldExpr(v:lnum)
    set foldtext=PythonFoldText()
    echo
endfunction

