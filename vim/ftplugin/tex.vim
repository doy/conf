let b:tex_flavor="latex"

" :make converts to pdf
setlocal makeprg=(cd\ /tmp\ &&\ pdflatex\ --synctex=1\ --halt-on-error\ %:p)

function! s:zathura()
    if s:is_running('^zathura')
        " zathura automatically reloads
        return
    endif
    call remote_startserver("vim-zathura")
    call system('zathura --fork -x "vim --servername vim-zathura --remote +%{line} %{input}" ' . s:current_pdf())
endfunction

function! s:current_pdf()
    let base = expand('<afile>:t:r')
    if base == ''
        let base = expand('%:t:r')
    endif
    return '/tmp/' . base . '.pdf'
endfunction

function! s:is_running(re)
    let processes = split(system('ps xo args'), '\n')
    for process in processes
        if process =~ a:re
            return 1
        endif
    endfor
    return 0
endfunction

function! Synctex()
    if s:is_running('^zathura')
        exe "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . expand('%:p') . " " . s:current_pdf()
        redraw
    endif
endfunction

" don't load the pdf if the make failed
function! s:make_errors()
    let qf = getqflist()
    for line in qf
        if line['type'] == 'E'
            return 1
        endif
    endfor
    return 0
endfunction

augroup _tex
    autocmd!
    if executable('zathura') && strlen(expand('$DISPLAY'))
        autocmd QuickFixCmdPost make if !s:make_errors() | call s:zathura() | endif
    endif
    autocmd CursorMoved <buffer> call Synctex()
augroup END

" see :help errorformat-LaTeX
setlocal errorformat=
    \%E!\ LaTeX\ %trror:\ %m,
    \%E!\ %m,
    \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
    \%+W%.%#\ at\ lines\ %l--%*\\d,
    \%WLaTeX\ %.%#Warning:\ %m,
    \%Cl.%l\ %m,
    \%+C\ \ %m.,
    \%+C%.%#-%.%#,
    \%+C%.%#[]%.%#,
    \%+C[]%.%#,
    \%+C%.%#%[{}\\]%.%#,
    \%+C<%.%#>%.%#,
    \%C\ \ %m,
    \%-GSee\ the\ LaTeX%m,
    \%-GType\ \ H\ <return>%m,
    \%-G\ ...%.%#,
    \%-G%.%#\ (C)\ %.%#,
    \%-G(see\ the\ transcript%.%#),
    \%-G\\s%#,
    \%+O(%f)%r,
    \%+P(%f%r,
    \%+P\ %\\=(%f%r,
    \%+P%*[^()](%f%r,
    \%+P[%\\d%[^()]%#(%f%r,
    \%+Q)%r,
    \%+Q%*[^()])%r,
    \%+Q[%\\d%*[^()])%r
