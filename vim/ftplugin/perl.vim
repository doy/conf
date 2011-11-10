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
nmap <buffer> <silent>K :call Help(0, [':'], '<SID>perldoc')<CR>
vmap <buffer> <silent>K :call Help(1, [':'], '<SID>perldoc')<CR>

nmap <buffer> <silent>gf :exe v:count . 'find ' . substitute(expand('<cfile>'), '::', '/', 'g') . '.pm'<CR>
" XXX: <cfile> is wrong here, need to do something like i do for Help
"vmap <buffer> <silent>gf :exe v:count . 'find ' . substitute(expand('<cfile>'), '::', '/', 'g') . '.pm'<CR>
nnoremap <buffer> t :FufCoverageFile lib/<CR>

function! s:unpostfix()
    let postop_pattern = '\<\(if\|unless\|while\|until\|for\)\>'
    let indent = repeat(' ', &sw)

    if getline('.') =~ postop_pattern
        normal kJ
    else
        normal J
    endif

    " XXX this doesn't insert newlines properly
    " let line = getline('.')
    " let line = substitute(
    "     \line,
    "     \'\(\s*\)\(.*\) ' . postop_pattern . ' \(.*\);',
    "     \'\1\3 (\4) {\1' . indent . '\2;\n\1}',
    "     \''
    " \)
    " call setline('.', line)
    exe 's/\(\s*\)\(.*\) ' . postop_pattern . ' \(.*\);/\1\3 (\4) {\r\1' . indent . '\2;\r\1}/'
endfunction

map <buffer> <silent> <Leader>i :call <SID>unpostfix()<CR>

let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
