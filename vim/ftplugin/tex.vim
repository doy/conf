" :make converts to pdf
if strlen(system('which xpdf')) && strlen(expand('$DISPLAY'))
    setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t\ &&\ xpdf\ $(echo\ %:t\ \\\|\ sed\ \'s/\\(\\.[^.]*\\)\\?$/.pdf/\'))
elseif strlen(system('which evince')) && strlen(expand('$DISPLAY'))
    setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t\ &&\ evince\ $(echo\ %:t\ \\\|\ sed\ \'s/\\(\\.[^.]*\\)\\?$/.pdf/\'))
else
    setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t)
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
