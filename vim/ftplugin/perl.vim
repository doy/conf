" :make does a syntax check
setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
setlocal errorformat=%f:%l:%m

" look up words in perldoc rather than man for K
function! s:perldoc(word)
    let perldoc_pager = $PERLDOC_PAGER
    let $PERLDOC_PAGER = 'cat'
    exe 'read! perldoc -f "' . a:word . '" 2>/dev/null || perldoc "' . a:word . '"'
    try
        silent %s/\%x1b\[\d\+m//g
        silent %s/.\%x08//g
    catch /.*/
    endtry
    normal ggdd
    let $PERLDOC_PAGER = perldoc_pager
    set ft=man
endfunction
nmap <silent>K :call Help(0, [':'], '<SID>perldoc')<CR>
vmap <silent>K :call Help(1, [':'], '<SID>perldoc')<CR>

" treat use lines as include lines (for tab completion, etc)
" XXX: it would be really sweet to make gf work with this, but unfortunately
" that checks the filename directly first, so things like 'use Moose' bring
" up the $LIB/Moose/ directory, since it exists, before evaluating includeexpr
setlocal include=\\s*use\\s*
setlocal includeexpr=substitute(v:fname,'::','/','g').'.pm'
exe "setlocal path=" . system("perl -e 'print join \",\", @INC;'") . ",lib"
