function! Help(visual, iskeyword, command)
    let l:iskeyword = &iskeyword
    for l:kw in a:iskeyword
        exe 'set iskeyword+=' . l:kw
    endfor
    if a:visual
        let l:oldreg = @a
        normal! gv"aygv
        let l:word = @a
        let @a = l:oldreg
    else
        let l:word = expand('<cword>')
    endif
    let &iskeyword = l:iskeyword

    exe 'noswapfile ' . &helpheight . 'new ' . l:word
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal nobuflisted

    setlocal modifiable
    exe 'call ' . a:command . '("' . l:word . '")'
    normal! ggdd
    setlocal nomodifiable
endfunction

function! s:man(word)
    exe 'silent read! man -Pcat ' . a:word
    setlocal filetype=man
endfunction

nnoremap <silent>K :call Help(0, [], '<SID>man')<CR>
xnoremap <silent>K :call Help(1, [], '<SID>man')<CR>
