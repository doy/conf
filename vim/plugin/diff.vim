let s:foldmethod = &foldmethod
let s:foldenable = &foldenable
let s:diffwindow = 0

function! s:diffstart(read_cmd)
    if s:diffwindow != 0
        return
    endif
    let s:foldmethod = &foldmethod
    let s:foldenable = &foldenable
    let l:filetype = &filetype
    vert new
    let s:diffwindow = winnr()
    set buftype=nofile
    try
        exe a:read_cmd
    catch /.*/
        echohl ErrorMsg
        echo v:exception
        echohl NONE
        call s:diffstop()
        return
    endtry
    let &filetype = l:filetype
    diffthis
    wincmd p
    diffthis
endfunction

function! s:diffstop()
    if s:diffwindow == 0
        return
    endif
    diffoff!
    exe s:diffwindow . 'wincmd w'
    bdelete
    let &foldmethod = s:foldmethod
    let &foldenable = s:foldenable
    if &foldenable
        if &foldmethod == 'marker'
            normal! zv
        else
            normal! zE
        end
    endif
    let s:diffwindow = 0
endfunction

function! s:vcs_orig(file)
    " XXX: would be nice to use a:file rather than # here...
    let l:dir = expand('#:p:h')
    if filewritable(l:dir . '/.svn') == 2
        return system('svn cat ' . a:file)
    elseif filewritable(l:dir . '/CVS') == 2
        return system("AFILE=" . a:file . "; MODFILE=`tempfile`; DIFF=`tempfile`; cp $AFILE $MODFILE && cvs diff -u $AFILE > $DIFF; patch -R $MODFILE $DIFF 2>&1 > /dev/null && cat $MODFILE; rm $MODFILE $DIFF")
    elseif finddir('_darcs', l:dir . ';') =~# '_darcs'
        return system('darcs show contents ' . a:file)
    elseif finddir('.git', l:dir . ';') =~# '.git'
        let l:prefix = system('git rev-parse --show-prefix')
        let l:prefix = substitute(l:prefix, '\n', '', 'g')
        let l:cmd = 'git show HEAD:'.l:prefix.a:file
        return system(l:cmd)
    else
        throw 'No VCS directory found'
    endif
endfunction

nnoremap <silent>ds :call <SID>diffstart('read # <bar> normal! ggdd')<CR>
nnoremap <silent>dc :call <SID>diffstart('call append(0, split(s:vcs_orig(expand("#:.")), "\n", 1)) <bar> normal! Gdddd')<CR>
nnoremap <silent>de :call <SID>diffstop()<CR>
