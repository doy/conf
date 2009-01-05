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

nmap <silent>gf :exe v:count . 'find ' . substitute(expand('<cfile>'), '::', '/', 'g') . '.pm'<CR>
