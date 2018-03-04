let g:perl_fold = 0
let b:ale_linters = { 'perl': ['perlcritic'] }
" rainbow parens break syntax-based indent
autocmd vimrc BufEnter <buffer> let b:indent_use_syntax = 0

" look up words in perldoc rather than man for K
function! s:perldoc(word)
    exe 'silent read! perldoc -o PlainText -f "' . a:word . '" 2>/dev/null || perldoc -o PlainText "' . a:word . '"'
    setlocal ft=man
endfunction
nnoremap <buffer> <silent>K :call Help(0, [':'], '<SID>perldoc')<CR>
vnoremap <buffer> <silent>K :call Help(1, [':'], '<SID>perldoc')<CR>

function! s:set_excludes()
    if filereadable("dist.ini")
        for line in readfile("dist.ini", '', 10)
            let name = matchstr(line, '\s*name\s*=\s*\zs.*')
            if name != ""
                exe 'setlocal wildignore+=' . name . '-*/*'
                break
            endif
        endfor
    endif
endfunction
autocmd BufReadPost * call <SID>set_excludes()
call <SID>set_excludes()
