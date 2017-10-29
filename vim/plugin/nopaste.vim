function! s:nopaste(visual)
    if a:visual
        silent normal! gv:!nopaste<CR>
    else
        let l:pos = getpos('.')
        silent normal! :%!nopaste<CR>
    endif
    silent normal! "+yy
    let @* = @+
    silent undo
    " can't restore visual selection because that will overwrite "*
    if !a:visual
        call setpos('.', l:pos)
    endif
    echo @+
endfunction

nnoremap <silent><Leader>p :call <SID>nopaste(0)<CR>
xnoremap <silent><Leader>p :<C-U>call <SID>nopaste(1)<CR>
