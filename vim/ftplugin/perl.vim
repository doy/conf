" :make does a syntax check
if expand("%:e") == "psgi"
    exe 'setlocal makeprg=plackup\ -Ilib\ -a\ ' . expand("%")
else
    setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
    setlocal errorformat=%f:%l:%m
endif

" look up words in perldoc rather than man for K
function! s:perldoc(word)
    let perldoc_pager = $PERLDOC_PAGER
    let $PERLDOC_PAGER = 'cat'
    exe 'silent read! perldoc -f "' . a:word . '" 2>/dev/null || perldoc "' . a:word . '"'
    let $PERLDOC_PAGER = perldoc_pager
    set ft=man
endfunction
nmap <silent>K :call Help(0, [':'], '<SID>perldoc')<CR>
vmap <silent>K :call Help(1, [':'], '<SID>perldoc')<CR>

nmap <silent>gf :exe v:count . 'find ' . substitute(expand('<cfile>'), '::', '/', 'g') . '.pm'<CR>
" XXX: <cfile> is wrong here, need to do something like i do for Help
"vmap <silent>gf :exe v:count . 'find ' . substitute(expand('<cfile>'), '::', '/', 'g') . '.pm'<CR>
nnoremap t :FufCoverageFile lib/<CR>
