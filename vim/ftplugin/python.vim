" look up words in pydoc rather than man for K
function! s:pydoc(word)
    let l:pydoc_pager = $MANPAGER
    let $MANPAGER = 'cat'
    exe 'silent read! pydoc "' . a:word . '" 2>/dev/null'
    let $MANPAGER = l:pydoc_pager
endfunction
nnoremap <buffer> <silent>K :call Help(0, [':'], '<SID>pydoc')<CR>
vnoremap <buffer> <silent>K :call Help(1, [':'], '<SID>pydoc')<CR>
