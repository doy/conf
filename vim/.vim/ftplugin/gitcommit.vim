setlocal viminfo=
augroup local_gitcommit
    autocmd!
    autocmd BufWinEnter <buffer>
        \ if getline(1) == '' |
            \ exe "normal! ggO" |
            \ startinsert |
        \ endif
augroup END
