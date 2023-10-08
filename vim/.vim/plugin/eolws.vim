augroup eolws
    autocmd!
    autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
    autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
augroup END
highlight EOLWS ctermbg=red guibg=red
