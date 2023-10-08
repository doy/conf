function! s:rubocop_in_bundler()
    let l:gemfiles = glob("*.gemspec", 1, 1)
    if filereadable("Gemfile")
        let l:gemfiles += ["Gemfile"]
    endif
    for l:file in l:gemfiles
        for l:line in readfile(l:file)
            if l:line =~ 'gem.*rubocop'
                return 1
            endif
        endfor
    endfor
    return 0
endfunction
if s:rubocop_in_bundler()
    let b:ale_ruby_rubocop_executable = 'bundle'
endif

" look up words in ri rather than man for K
function! s:ri(word)
    exe 'silent read! ri -T -f rdoc "' . a:word . '" 2>/dev/null'
    setlocal ft=
endfunction
nnoremap <buffer> <silent>K :call Help(0, [':', '.'], '<SID>ri')<CR>
vnoremap <buffer> <silent>K :call Help(1, [':', '.'], '<SID>ri')<CR>
