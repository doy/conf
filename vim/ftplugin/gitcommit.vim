setlocal viminfo=
augroup local_gitcommit
    autocmd!
    autocmd BufWinEnter <buffer> exe "normal! ggO" | startinsert
augroup END
