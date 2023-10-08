setlocal cindent
setlocal cinoptions+=:0,l1,g0,(0,W1s

" look up words in perldoc rather than man for K if they exist
function! s:perldoc_or_man(word)
    exe 'silent read! perldoc -o PlainText -a "' . a:word . '" 2>/dev/null || man -Pcat ' . a:word
    setlocal ft=man
endfunction
nnoremap <buffer> <silent>K :call Help(0, [], '<SID>perldoc_or_man')<CR>
vnoremap <buffer> <silent>K :call Help(1, [], '<SID>perldoc_or_man')<CR>
