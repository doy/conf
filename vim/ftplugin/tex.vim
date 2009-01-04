" :make converts to pdf
setlocal makeprg=(cd\ /tmp\ &&\ pdflatex\ --halt-on-error\ %:p)

" xpdf needs to be manually refreshed when the file changes
function s:xpdf()
    let pdf = '/tmp/' . expand('<afile>:t:r') . '.pdf'
    let processes = split(system('ps xo args'), '\n')
    for process in processes
        if process =~ 'xpdf -remote localhost'
            call system('xpdf -remote localhost -reload')
            return
        endif
    endfor
    call system('xpdf -remote localhost ' . pdf . ' &')
endfunction
" evince treats opening the same file twice as meaning 'reload'
function s:evince()
    let pdf = '/tmp/' . expand('<afile>:t:r') . '.pdf'
    system('evince ' . pdf . ' &')
endfunction
" don't load the pdf if the make failed
function s:make_errors()
    let qf = getqflist()
    for line in qf
        if line['type'] == 'E'
            return 1
        endif
    endfor
    return 0
endfunction
if executable('xpdf') && strlen(expand('$DISPLAY'))
    autocmd QuickFixCmdPost make if !s:make_errors() | call s:xpdf()   | endif
elseif executable('evince') && strlen(expand('$DISPLAY'))
    autocmd QuickFixCmdPost make if !s:make_errors() | call s:evince() | endif
endif

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
