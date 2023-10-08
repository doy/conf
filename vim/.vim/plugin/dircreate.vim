function! s:ensure_dir_exists()
    let l:required_dir = expand("%:h")
    if !isdirectory(l:required_dir)
        if <SID>ask_quit("Directory '" . l:required_dir . "' doesn't exist.", "&Create it?")
            return
        endif

        try
            call mkdir(l:required_dir, 'p')
        catch
            call <SID>ask_quit("Can't create '" . l:required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction

function! s:ask_quit(msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        if len(getbufinfo()) > 1
            silent bd
            return 1
        else
            exit
        end
    endif
    return 0
endfunction

augroup dircreate
    autocmd!
    autocmd BufNewFile * call <SID>ensure_dir_exists()
augroup END
