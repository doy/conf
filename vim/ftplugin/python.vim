" look up words in pydoc rather than man for K
function! s:pydoc(word)
    let l:pydoc_manpager = $MANPAGER
    let l:pydoc_pager = $PAGER
    let $MANPAGER = 'cat'
    let $PAGER = 'cat'
    exe 'silent read! pydoc "' . a:word . '" 2>/dev/null'
    let $MANPAGER = l:pydoc_manpager
    let $PAGER = l:pydoc_pager
    setlocal ft=man
endfunction
nnoremap <buffer> <silent>K :call Help(0, ['.'], '<SID>pydoc')<CR>
vnoremap <buffer> <silent>K :call Help(1, ['.'], '<SID>pydoc')<CR>
