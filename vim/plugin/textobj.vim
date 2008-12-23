" Text object creation {{{
" XXX: use virtualedit here, it should greatly simplify things
let s:text_object_number = 0
function Textobj(char, callback, ...)
    let s:text_object_number += 1
    function s:textobj_{s:text_object_number}(inner, operator, count, callback)
        try
            let pos = getpos('.')
            sandbox let [startline, startcol, endline, endcol] = call(a:callback, [a:inner, a:count] + a:000)
        catch /no-match/
            return
        finally
            call setpos('.', pos)
        endtry
        if startline == endline
            let objlength = endcol - startcol + 1
        else
            let objlength = 0
            if endline - startline > 1
                exe 'let objlength += '.join(map(getline(startline + 1, endline - 1), 'strlen(v:val) + 1'), '+')
            endif
            let objlength += endcol + strlen(getline(startline)) - startcol + 2
        endif
        let whichwrap = &whichwrap
        set whichwrap+=s
        let virtualedit = &virtualedit
        if startcol > strlen(getline(startline))
            let startcol = 1
            let startline += 1
            let objlength -= 1
        endif
        if endcol == 0
            set virtualedit=onemore
        endif
        if a:operator == 'v'
            let objlength -= 1
        endif
        call cursor(startline, startcol)
        if a:operator == 'c'
            let operator = 'd'
        else
            let operator = a:operator
        end
        exe 'normal! '.operator.objlength.' '

        if a:operator == 'c'
            startinsert
        endif
        let &whichwrap = whichwrap
        let &virtualedit = virtualedit
    endfunction

    exe 'onoremap <silent>a'.a:char.' <Esc>:call <SID>textobj_'.s:text_object_number.'(0, v:operator, v:prevcount, "'.a:callback.'")<CR>'
    exe 'onoremap <silent>i'.a:char.' <Esc>:call <SID>textobj_'.s:text_object_number.'(1, v:operator, v:prevcount, "'.a:callback.'")<CR>'
    exe 'xnoremap <silent>a'.a:char.' <Esc>:call <SID>textobj_'.s:text_object_number.'(0, "v", v:prevcount, "'.a:callback.'")<CR>'
    exe 'xnoremap <silent>i'.a:char.' <Esc>:call <SID>textobj_'.s:text_object_number.'(1, "v", v:prevcount, "'.a:callback.'")<CR>'
endfunction
" }}}
" Text object definitions {{{
" / for regex {{{
function s:textobj_regex(inner, count)
    let pos = getpos('.')

    let line = strpart(getline(pos[1]), 0, pos[2])
    let lines = getline(1, pos[1] - 1) + [line]
    let linenum = pos[1]
    for line in reverse(lines)
        let objstart = match(line, '.*\zs\\\@<!/') + 1
        if objstart != 0
            break
        endif
        let linenum -= 1
    endfor
    if objstart == 0
        throw 'no-match'
    endif
    let objstart += a:inner
    let objstartline = linenum

    let line = strpart(getline(pos[1]), pos[2] - 1)
    let lines = [line] + getline(pos[1] + 1, line('$'))
    let linenum = pos[1]
    for line in lines
        let objend = match(line, '\\\@<!/') + 1
        if objend != 0
            if linenum == pos[1]
                " have to account for the possibility of a split escape
                " sequence
                if objend == 1
                    if getline(pos[1])[pos[2] - 2] == '\'
                        let objend = match(line, '\\\@<!/', 1) + 1
                        if objend == 0
                            let linenum += 1
                            continue
                        endif
                    else
                        " if we're sitting on a /, don't do anything, since it's
                        " impossible to know which direction to look
                        throw 'no-match'
                    endif
                endif
                let objend += pos[2] - 1
            endif
            break
        endif
        let linenum += 1
    endfor
    if objend == 0
        throw 'no-match'
    endif
    let objend -= a:inner
    let objendline = linenum

    return [objstartline, objstart, objendline, objend]
endfunction
" }}}
" f for folds {{{
function Textobj_fold(inner, count)
    if foldlevel(line('.')) == 0
        throw 'no-match'
    endif
    exe 'normal! '.a:count.'[z'
    let startline = line('.') + a:inner
    normal! ]z
    let endline = line('.') - a:inner

    return [startline, 1, endline, strlen(getline(endline))]
endfunction
" }}}
" , for function arguments {{{
function Textobj_arg(inner, count)
    let pos = getpos('.')
    let curchar = getline(pos[1])[pos[2] - 1]
    if curchar == ','
        if getline(pos[1])[pos[2] - 2] =~ '\s'
            normal! gE
        else
            exe "normal! \<BS>"
        endif
        return s:textobj_arg(a:inner, a:count)
    elseif curchar =~ '\s'
        normal! W
        return s:textobj_arg(a:inner, a:count)
    endif

    let line = strpart(getline(pos[1]), 0, pos[2])
    let lines = getline(1, pos[1] - 1) + [line]
    let linenum = pos[1]
    for line in reverse(lines)
        let argbegin = matchend(line, '.*\%(,\s*\|(\)') + 1
        if argbegin != 0
            while argbegin > strlen(line)
                let linenum += 1
                let line = getline(linenum)
                let argbegin = matchend(line, '^\s*') + 1
            endwhile
            break
        endif
        let linenum -= 1
    endfor
    if argbegin == 0
        throw 'no-match'
    endif
    let argstartline = linenum

    let line = strpart(getline(pos[1]), pos[2] - 1)
    let lines = [line] + getline(pos[1] + 1, line('$'))
    let linenum = pos[1]
    for line in lines
        let argend = match(line, '\zs.\?\%(,\|)\)') + 1
        if argend != 0
            if linenum == pos[1]
                let argend += pos[2] - 1
            endif
            if argend == 1 && getline(linenum)[argend - 1] == ')'
                let linenum -= 1
                let argend = strlen(getline(linenum))
            endif
            break
        endif
        let linenum += 1
    endfor
    if argend == 0
        throw 'no-match'
    endif
    let argendline = linenum

    if a:inner == 0
        let endline = getline(argendline)
        let startline = getline(argstartline)
        if argend >= strlen(endline)
            let argend = 0
            let argendline += 1
            let endline = getline(argendline)
        endif
        if endline[argend] == ')' && startline[argbegin - 2] != '('
            let argbegin = match(strpart(startline, 0, argbegin - 1), '\s*$')
            while argbegin == 0
                let argstartline -= 1
                let startline = getline(argstartline)
                let argbegin = strlen(startline)
            endwhile
        elseif endline[argend] != ')'
            let argend += matchend(strpart(endline, argend + 1), '^\s*') + 1
            if startline[argbegin - 2] == '('
                for line in [strpart(endline, argend)] +
                \           getline(argendline + 1, line('$'))
                    let argincr = matchend(line, '\s*\ze\S')
                    if argincr != -1
                        let argend += argincr
                        break
                    endif
                    let argendline += 1
                    let argend = 0
                endfor
            endif
        endif
        if argend >= strlen(endline)
            if argendline == argstartline
                let newbegin = matchend(strpart(endline, 0, argbegin), '.*,')
                if newbegin != -1
                    let argbegin = newbegin + 1
                endif
            endif
            let argend = 0
            let argendline += 1
        endif
    endif

    return [argstartline, argbegin, argendline, argend]
endfunction
" }}}
" }}}
