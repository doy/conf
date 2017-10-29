let s:pair_chars = {
\    '(': ')',
\    '[': ']',
\    '{': '}',
\}
let s:pair_cr_maps = {
\    '(': "<SID>go_up()",
\    '[': "<SID>go_up()",
\    '{': "<SID>go_up()",
\}
let s:pair_bs_maps = {
\    '"': "<SID>maybe_remove_adjacent_char('\"')",
\    "'": "<SID>maybe_remove_adjacent_char(\"'\")",
\    '(': "<SID>maybe_remove_empty_pair(')')",
\    '[': "<SID>maybe_remove_empty_pair(']')",
\    '{': "<SID>maybe_remove_empty_pair('}')",
\    '': "<SID>maybe_collapse_pair()",
\}

function! s:move_cursor_left()
    return "\<Esc>i"
endfunction

function! s:skip_closing_char(char)
    if s:nextchar() == a:char
        return "\<Esc>la"
    else
        return a:char
    endif
endfunction

function! s:has_bs_mapping(char)
    return has_key(s:pair_bs_maps, a:char)
endfunction

function! s:run_bs_mapping(char)
    return eval(s:pair_bs_maps[a:char])
endfunction

function! s:has_cr_mapping(char)
    return has_key(s:pair_cr_maps, a:char)
endfunction

function! s:run_cr_mapping(char)
    return eval(s:pair_cr_maps[a:char])
endfunction

function! s:go_up()
    return "\<CR>\<Esc>O"
endfunction

function! s:maybe_remove_adjacent_char(char)
    if s:nextchar() == a:char
        return "\<BS>\<Del>"
    else
        return "\<BS>"
    endif
endfunction

function! s:maybe_remove_empty_pair(char)
    let l:start = [line('.'), col('.')]
    let l:end = searchpos('[^ \t]', 'cnWz')
    if l:end == [0, 0]
        return "\<BS>"
    endif

    let l:next_nonblank = s:charat(l:end[0], l:end[1])
    if l:next_nonblank != a:char
        return "\<BS>"
    endif

    let l:diff = [l:end[0] - l:start[0], l:end[1] - l:start[1]]
    if l:diff[0] == 0
        return "\<BS>" . repeat("\<Del>", l:diff[1] + 1)
    elseif l:diff[0] == 1
        return "\<Esc>" . (l:diff[0] + 1) . "Ji" . "\<BS>\<Del>\<Del>"
    else
        return "\<Esc>" . (l:diff[0] + 1) . "Ji" . "\<BS>\<BS>\<Del>"
    endif
endfunction

function! s:maybe_collapse_pair()
    let l:prev_line_idx = line('.') - 1
    if l:prev_line_idx < 1
        return "\<BS>"
    endif

    let l:prev_line_char = s:charat(l:prev_line_idx, col([l:prev_line_idx, '$']) - 1)
    if l:prev_line_char !~ '[([{]'
        return "\<BS>"
    endif

    let l:end = searchpos('[^ \t]', 'cnWz')
    if l:end == [0, 0]
        return "\<BS>"
    endif

    let l:next_nonblank = s:charat(l:end[0], l:end[1])
    if l:next_nonblank != s:pair_chars[l:prev_line_char]
        return "\<BS>"
    endif

    return "\<Esc>\<BS>JJi\<BS>"
endfunction

function! s:prevchar()
    return s:charat(line('.'), col('.') - 1)
endfunction

function! s:nextchar()
    return s:charat(line('.'), col('.'))
endfunction

function! s:charat(line, col)
    return getline(a:line)[a:col - 1]
endfunction

for [s:start, s:end] in [['(', ')'], ['{', '}'], ['[', ']']]
    exe "inoremap <silent> ".s:start.
        \ " ".s:start.s:end."<C-R>=<SID>move_cursor_left()<CR>"
    exe "inoremap <silent> ".s:end.
        \ " <C-R>=<SID>skip_closing_char('".s:end."')<CR>"
endfor
inoremap <silent><expr> '
    \ <SID>nextchar() == "'"
        \ ? "\<C-R>=\<SID>skip_closing_char(\"'\")\<CR>"
        \ : col('.') == 1 \|\| match(<SID>prevchar(), '\W') != -1
            \ ? "''\<C-R>=\<SID>move_cursor_left()\<CR>"
            \ : "'"
inoremap <silent><expr> "
    \ <SID>nextchar() == '"'
        \ ? "\<C-R>=\<SID>skip_closing_char('\"')\<CR>"
        \ : "\"\"\<C-R>=\<SID>move_cursor_left()\<CR>"
inoremap <silent><expr> <BS>
    \ <SID>has_bs_mapping(<SID>prevchar())
        \ ? "\<C-R>=\<SID>run_bs_mapping(\<SID>prevchar())\<CR>"
        \ : "\<BS>"
inoremap <silent><expr> <CR>
    \ <SID>has_cr_mapping(<SID>prevchar())
        \ ? "\<C-R>=\<SID>run_cr_mapping(\<SID>prevchar())\<CR>"
        \ : "\<CR>"
