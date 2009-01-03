" :make does a syntax check
setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
setlocal errorformat=%f:%l:%m

" look up words in perldoc rather than man for K
setlocal keywordprg=perldoc\ -f

" treat use lines as include lines (for tab completion, etc)
" XXX: it would be really sweet to make gf work with this, but unfortunately
" that checks the filename directly first, so things like 'use Moose' bring
" up the $LIB/Moose/ directory, since it exists, before evaluating includeexpr
setlocal include=\\s*use\\s*
setlocal includeexpr=substitute(v:fname,'::','/','g').'.pm'
exe "setlocal path=" . system("perl -e 'print join \",\", @INC;'") . ",lib"
