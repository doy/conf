let b:ale_linters = { 'perl': ['perlcritic'] }

" look up words in perldoc rather than man for K
function! s:perldoc(word)
    let perldoc_pager = $PERLDOC_PAGER
    let $PERLDOC_PAGER = 'cat'
    exe 'silent read! perldoc -f "' . a:word . '" 2>/dev/null || perldoc "' . a:word . '"'
    let $PERLDOC_PAGER = perldoc_pager
    setlocal ft=man
endfunction
nnoremap <buffer> <silent>K :call Help(0, [':'], '<SID>perldoc')<CR>
vnoremap <buffer> <silent>K :call Help(1, [':'], '<SID>perldoc')<CR>
