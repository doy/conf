let b:tex_flavor="latex"

" :make converts to pdf
setlocal makeprg=(cd\ /tmp\ &&\ pdflatex\ --synctex=1\ --halt-on-error\ %:p)

" xpdf needs to be manually refreshed when the file changes
function! s:xpdf()
    if s:is_running('xpdf -remote localhost')
        call system('xpdf -remote localhost -reload')
        return
    endif
    call system('xpdf -remote localhost ' . s:current_pdf() . ' &')
endfunction

" evince treats opening the same file twice as meaning 'reload'
function! s:evince()
    call system('evince ' . s:current_pdf() . ' &')
endfunction

" zathura automatically reloads
function! s:zathura()
    if s:is_running('^zathura')
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

let b:automake_enabled = 0
function! s:automake()
    let old_shellpipe = &shellpipe
    let &shellpipe = '>'
    try
        silent make!
    finally
        let &shellpipe = old_shellpipe
    endtry
endfunction

augroup _tex
    autocmd!
    if executable('zathura') && strlen(expand('$DISPLAY'))
        autocmd QuickFixCmdPost make if !s:make_errors() | call s:zathura() | endif
    elseif executable('xpdf') && strlen(expand('$DISPLAY'))
        autocmd QuickFixCmdPost make if !s:make_errors() | call s:xpdf()    | endif
    elseif executable('evince') && strlen(expand('$DISPLAY'))
        autocmd QuickFixCmdPost make if !s:make_errors() | call s:evince()  | endif
    endif
    autocmd CursorHold,CursorHoldI,InsertLeave <buffer> if b:automake_enabled | call s:automake() | endif
    autocmd CursorMoved <buffer> call Synctex()
augroup END

noremap <buffer> <silent><F6> :let b:automake_enabled = !b:automake_enabled<CR><F5>
inoremap <buffer> <silent><F6> <C-O>:let b:automake_enabled = !b:automake_enabled<CR><C-O><F5>

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
