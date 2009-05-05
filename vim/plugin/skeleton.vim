function s:read_skeleton(pattern)
    set modifiable
    " the skeleton file should be a file in ~/.vim/skeletons that matches the
    " glob pattern of files that it should be loaded for
    let skeleton_file = glob("~/.vim/skeletons/".a:pattern)
    " read leaves a blank line at the top of the file
    exe "silent read ".skeleton_file." | normal ggdd"
    let lines = getline(1, "$")
    normal ggdG
    for line in lines
        " sigh... this is *so* dumb
        let remove_extra_line = 0
        if line('$') == 1 && col('$') == 1
            let remove_extra_line = 1
        endif
        " lines starting with :: will start with a literal :
        if line =~ '^::'
            call append(line('$'), strpart(line, 1))
            normal G
            if remove_extra_line
                normal ggdd
            endif
        " lines not starting with a : will just be appended literally
        elseif line !~ '^:'
            call append(line('$'), line)
            normal G
            if remove_extra_line
                normal ggdd
            endif
        else
            exe line
        endif
    endfor
    redraw
endfunction

function Skeleton(pattern)
    exe "autocmd BufNewFile ".a:pattern." silent call s:read_skeleton(\"".a:pattern."\")"
endfunction

for pattern in g:Skeleton_patterns
    call Skeleton(pattern)
endfor
unlet pattern
