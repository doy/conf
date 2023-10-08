let b:ale_linters = { 'perl': ['perlcritic'] }
" rainbow parens break syntax-based indent
autocmd vimrc BufEnter <buffer> let b:indent_use_syntax = 0

" look up words in perldoc rather than man for K
function! s:perldoc(word)
    exe 'silent read! perldoc -o PlainText -f "' . a:word . '" 2>/dev/null || perldoc -o PlainText "' . a:word . '"'
    setlocal ft=man
endfunction
nnoremap <buffer> <silent>K :call Help(0, [':'], '<SID>perldoc')<CR>
vnoremap <buffer> <silent>K :call Help(1, [':'], '<SID>perldoc')<CR>
