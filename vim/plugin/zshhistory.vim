" see 'vim' alias in zshrc
if $SHELL !~# 'zsh' || !exists('g:_zsh_hist_fname')
    finish
endif

let s:initial_files = {}

augroup zshhistory
    autocmd!
    autocmd VimEnter * call <SID>init_zsh_hist()
    autocmd BufNewFile,BufRead * call <SID>zsh_hist_append()
    autocmd BufDelete * call <SID>remove_initial_file(expand("<afile>"))
    autocmd VimLeave * call <SID>reorder_zsh_hist()
augroup END

function! s:remove_initial_file (file)
    if has_key(s:initial_files, a:file)
        unlet s:initial_files[a:file]
    endif
endfunction

function! s:get_buffer_list_text ()
    redir => l:output
    ls!
    redir END
    return l:output
endfunction

function! s:get_buffer_list ()
    silent let l:output = <SID>get_buffer_list_text()
    let l:buffer_list = []
    for l:buffer_desc in split(l:output, "\n")
        let l:name = bufname(str2nr(l:buffer_desc))
        if l:name != ""
            call add(l:buffer_list, l:name)
        endif
    endfor
    return l:buffer_list
endfunction

function! s:init_zsh_hist ()
    for l:fname in <SID>get_buffer_list()
        let s:initial_files[l:fname] = 1
        call histadd(":", "e " . l:fname)
    endfor
    call delete(g:_zsh_hist_fname)
endfunction

function! s:zsh_hist_append ()
    let l:to_append = expand("%:~:.")
    " XXX these set buftype too late to be caught by this...
    " this is broken, but not sure what a better fix is
    if &buftype == '' && l:to_append !~# '^\(__Gundo\|Startify\|\[denite\]\)'
        if !has_key(s:initial_files, l:to_append)
            if filereadable(g:_zsh_hist_fname)
                let l:hist = readfile(g:_zsh_hist_fname)
            else
                let l:hist = []
            endif
            call add(l:hist, l:to_append)
            call writefile(l:hist, g:_zsh_hist_fname)
        endif
    endif
endfunction

function! s:reorder_zsh_hist ()
    let l:current_file = expand("%:~:.")
    if filereadable(g:_zsh_hist_fname)
        let l:hist = readfile(g:_zsh_hist_fname)
        if !has_key(s:initial_files, l:current_file)
            call filter(l:hist, 'v:val != l:current_file')
        endif
        call add(l:hist, l:current_file)
        call writefile(l:hist, g:_zsh_hist_fname)
    endif
endfunction
