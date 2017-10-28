function! s:rubocop_in_bundler()
    let gemfiles = glob("*.gemspec", 1, 1)
    if filereadable("Gemfile")
        let gemfiles += ["Gemfile"]
    endif
    for file in gemfiles
        for line in readfile(file)
            if line =~ 'gem.*rubocop'
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
    exe 'silent read! ri --no-pager "' . a:word . '" 2>/dev/null'
endfunction
nnoremap <buffer> <silent>K :call Help(0, [':'], '<SID>ri')<CR>
vnoremap <buffer> <silent>K :call Help(1, [':'], '<SID>ri')<CR>
