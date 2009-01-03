" based on Eidolos's .vimrc, at http://sartak.org/conf/vimrc

" General options {{{
" Miscellaneous {{{
set nocompatible

" indentation FTW.. also plugins FTW! heh
filetype indent plugin on

" automatically flush to disk when using :make, etc.
set autowrite

" automatically read in external changes if we haven't modified the buffer
set autoread

" Gentoo disables modelines by default
set modeline

" always join with just one space, even between sentences
set nojoinspaces

" vim has pretty nice mouse support, in terminals that support it
if has('mouse')
    set mouse=a
endif
" }}}
" Display {{{
" color!
syntax on

" lines, cols in status line
set ruler

" display more information in the ruler
set rulerformat=%40(%=%t%h%m%r%w%<\ (%n)\ %4.7l,%-7.(%c%V%)\ %P%)

" current mode in status line
set showmode

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" a - terse messages (like [+] instead of [Modified]
" o - don't show both reading and writing messages if both occur at once
" t - truncate file names
" T - truncate messages rather than prompting to press enter
" W - don't show [w] when writing
" I - no intro message when starting vim fileless
set shortmess=aotTWI

" no extra status lines
set laststatus=0

" display as much of the last line as possible if it's really long
" also display unprintable characters as hex
set display+=lastline,uhex

" give three lines of context when moving the cursor around
set scrolloff=3

" don't redraw the screen during macros etc (NetHack's runmode:teleport)
set lazyredraw

" highlight all matches, we'll see if this works with a different hilight
set hlsearch

" highlight matching parens for .2s
set showmatch
set matchtime=2

" threshold for reporting number of lines changed
set report=0

" I generally don't want to have to space through things.. :)
set nomore

" word wrapping
set linebreak

" only show a menu for completion, never a preview window or things like that
set completeopt=menuone

" Language specific features {{{
" Bash {{{
" I use bash
let g:is_bash=1
" }}}
" C/C++ {{{
" highlight end of line whitespace and spaces before tabs
let c_space_errors=1

" use c syntax for header files, rather than c++
let c_syntax_for_h=1

" highlight doxygen
let g:load_doxygen_syntax=1
" }}}
" LaTeX {{{
" I only use LaTeX
let g:tex_flavor="latex"
" }}}
" Perl {{{
" highlight advanced perl vars inside strings
let perl_extended_vars=1

" POD!
let perl_include_pod=1

" color quote marks differently from the actual string
let perl_string_as_statement=1

" perl needs lots of syncing...
let perl_sync_dist=1000
" }}}
" PostScript {{{
" highlight more things in postscripts files
let postscr_fonts=1
let postscr_encodings=1
" }}}
" }}}
" }}}
" Improve power of commands {{{
" backspace over autoindent, end of line (to join lines), and preexisting test
set backspace=indent,eol,start

" tab completion in ex mode
set wildmenu

" when doing tab completion, ignore files with any of the following extensions
set wildignore+=.log,.out,.o

" remember lotsa fun stuff
set viminfo=!,'1000,f1,/1000,:1000,<1000,@1000,h,n~/.viminfo

" add : as a file-name character (mostly for Perl's mod::ules)
set isfname+=:

" tab completion stuff for the command line
set wildmode=longest,list,full

" allow word completions from the system word list
set dictionary+=/usr/share/dict/words

" complete from the dictionary also
set complete+=k

set noincsearch
" }}}
" Make vim less whiny {{{
" :bn with a change in the current buffer? no prob!
set hidden

" no bells whatsoever
set vb t_vb=

" if you :q with changes it asks you if you want to continue or not
set confirm

" 50 milliseconds for escape timeout instead of 1000
set ttimeoutlen=50
" }}}
" Indentation {{{
" normal sized tabs!
set tabstop=8

" set to what i like (see #2 in :help tabstop)
set shiftwidth=4

" if it looks like a tab, we can delete it like a tab
set softtabstop=4

" no tabs! spaces only..
set expandtab

" < and > will hit indentation levels instead of always -4/+4
set shiftround

" new line has indentation equal to previous line
set autoindent

" braces affect autoindentation
set smartindent

" configure cindent for my coding style
set cinoptions+=b1,:0,l1,g0,(0,W1

" reindent whenever 'break;' is typed
set cinkeys+==break;
" }}}
" Folding {{{
" fold only when I ask for it damnit!
set foldmethod=marker
" }}}
" }}}
" Colors {{{
set bg=light
" word completion menu {{{
highlight Pmenu      ctermfg=grey  ctermbg=darkblue
highlight PmenuSel   ctermfg=red   ctermbg=darkblue
highlight PmenuSbar  ctermbg=cyan
highlight PmenuThumb ctermfg=red

highlight WildMenu ctermfg=grey ctermbg=darkblue
" }}}
" folding {{{
highlight Folded     ctermbg=black ctermfg=darkgreen
" }}}
" hlsearch {{{
highlight Search NONE ctermfg=red
" }}}
" color end of line whitespace {{{
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
hi EOLWS ctermbg=red
" }}}
" }}}
" Autocommands {{{
" When editing a file, always jump to the last cursor position {{{
autocmd BufReadPost *
\  if line("'\"") > 0 && line("'\"") <= line("$") |
\    exe "normal g`\"" |
\  endif
" }}}
" Skeletons {{{
function s:read_skeleton(pattern)
    " the skeleton file should be a file in ~/.vim/skeletons that matches the
    " glob pattern of files that it should be loaded for
    let skeleton_file = glob("~/.vim/skeletons/".a:pattern)
    " read leaves a blank line at the top of the file
    exe "silent read ".skeleton_file." | normal ggdd"
    let lines = getline(1, "$")
    normal ggdG
    for line in lines
        " lines starting with :: will start with a literal :
        if line =~ '^::'
            let line = ":normal i\<C-o>i" . strpart(line, 1) . "\<CR>"
        endif
        " lines not starting with a : will just be appended literally
        if line !~ '^:'
            let line = ":normal i\<C-o>i" . line . "\<CR>"
        endif
        exe line
    endfor
    " remove the last extra newline we added
    let pos = getpos('.')
    normal Gdd
    call setpos('.', pos)
endfunction
function s:skeleton(pattern)
    exe "autocmd BufNewFile ".a:pattern." silent call s:read_skeleton(\"".a:pattern."\")"
endfunction
for skel in ['*.pl', '*.pm', '*.cpp', '*.c', '*.tex', '*.t', 'Makefile', 'Makefile.PL']
    call s:skeleton(skel)
endfor
" }}}
" Auto +x {{{
au BufWritePost *.{sh,pl} silent exe "!chmod +x %"
" }}}
" Update ctags after writing {{{
autocmd BufWritePost * if filereadable('tags') | silent exe "!ctags -a %" | redraw | endif
" }}}
" Language specific things {{{
" Perl {{{
" :make does a syntax check
autocmd FileType perl setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType perl setlocal errorformat=%f:%l:%m

" look up words in perldoc rather than man for K
autocmd FileType perl setlocal keywordprg=perldoc\ -f

" treat use lines as include lines (for tab completion, etc)
" XXX: it would be really sweet to make gf work with this, but unfortunately
" that checks the filename directly first, so things like 'use Moose' bring
" up the $LIB/Moose/ directory, since it exists, before evaluating includeexpr
autocmd FileType perl setlocal include=\\s*use\\s*
autocmd FileType perl setlocal includeexpr=substitute(v:fname,'::','/','g').'.pm'
autocmd FileType perl exe "setlocal path=" . system("perl -e 'print join \",\", @INC;'") . ",lib"
" }}}
" Latex {{{
" :make converts to pdf
if strlen(system('which xpdf')) && strlen(expand('$DISPLAY'))
    autocmd FileType tex setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t\ &&\ xpdf\ $(echo\ %:t\ \\\|\ sed\ \'s/\\(\\.[^.]*\\)\\?$/.pdf/\'))
elseif strlen(system('which evince')) && strlen(expand('$DISPLAY'))
    autocmd FileType tex setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t\ &&\ evince\ $(echo\ %:t\ \\\|\ sed\ \'s/\\(\\.[^.]*\\)\\?$/.pdf/\'))
else
    autocmd FileType tex setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t)
endif
" see :help errorformat-LaTeX
autocmd FileType tex setlocal errorformat=
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
" }}}
" Lua {{{
" :make does a syntax check
autocmd FileType lua setlocal makeprg=luac\ -p\ %
autocmd FileType lua setlocal errorformat=luac:\ %f:%l:\ %m

" set commentstring
autocmd FileType lua setlocal commentstring=--%s

" treat require lines as include lines (for tab completion, etc)
autocmd FileType lua setlocal include=\\s*require\\s*
autocmd FileType lua setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'
autocmd FileType lua exe "setlocal path=" . system("lua -e 'local fpath = \"\" for path in package.path:gmatch(\"[^;]*\") do if path:match(\"\?\.lua$\") then fpath = fpath .. path:gsub(\"\?\.lua$\", \"\") .. \",\" end end print(fpath:gsub(\",,\", \",.,\"):sub(0, -2))'")
" }}}
" Vim {{{
autocmd FileType vim setlocal keywordprg=:help
" }}}
" }}}
" Misc {{{
autocmd BufWritePost .conkyrc silent exe "!killall -HUP conky"
autocmd QuickFixCmdPost * copen 3
" }}}
" }}}
" Remappings {{{
" Help file remappings for easy navigation {{{
autocmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd FileType help nnoremap <buffer> <BS> <C-T>
" }}}
" darcs convenience mappings {{{
nmap \da  :execute 'w  <bar> !darcs add %'<CR>
nmap \dA  :execute 'wa <bar> !darcs amend-record'<CR>
nmap \dr  :execute 'wa <bar> !darcs record'<CR>
nmap \dR  :execute 'w  <bar> !darcs record %'<CR>
nmap \dn  :execute 'wa <bar> !darcs whatsnew   <bar> less'<CR>
nmap \dN  :execute 'w  <bar> !darcs whatsnew % <bar> less'<CR>
nmap \dd  :execute 'wa <bar> !darcs diff -u    <bar> less'<CR>
nmap \dD  :execute 'w  <bar> !darcs diff -u %  <bar> less'<CR>
nmap \dc  :execute '!darcs changes             <bar> less'<CR>
nmap \dqm :execute '!darcs query manifest      <bar> less'<CR>
nmap \dt  :execute '!darcs tag'<CR>
nmap \dp  :execute '!darcs push'<CR>
nmap \du  :execute '!darcs unrecord'<CR>
nmap \db  :execute "w <bar> :execute '!darcs revert %'   <bar> :silent execute 'e'"<CR>
nmap \dB  :execute "w <bar> :execute '!darcs unrevert %' <bar> :silent execute 'e'"<CR>
"}}}
" Keep the current selection when indenting (thanks cbus) {{{
vnoremap < <gv
vnoremap > >gv
" }}}
" Painless spell checking (F11) {{{
function s:spell()
    if !exists("s:spell_check") || s:spell_check == 0
        echo "Spell check on"
        let s:spell_check = 1
        setlocal spell spelllang=en_us
    else
        echo "Spell check off"
        let s:spell_check = 0
        setlocal spell spelllang=
    endif
endfunction
map <F11> :call <SID>spell()<CR>
imap <F11> <C-o>:call <SID>spell()<CR>
" }}}
" diff between current file and its original state {{{
let s:foldmethod = &foldmethod
let s:foldenable = &foldenable
function s:diffstart(read_cmd)
    let s:foldmethod = &foldmethod
    let s:foldenable = &foldenable
    vert new
    set bt=nofile
    exe a:read_cmd
    normal 0d_
    diffthis
    wincmd p
    diffthis
endfunction
function s:diffstop()
    diffoff!
    wincmd t
    quit
    let &foldmethod = s:foldmethod
    let &foldenable = s:foldenable
endfunction
function s:vcs_orig(file)
    return system('darcs show contents ' . a:file)
endfunction
nmap <silent> ds :call <SID>diffstart('read #')<CR>
nmap <silent> dc :call <SID>diffstart('call append(0, split(s:vcs_orig(expand("#")), "\n", 1)) <bar> normal Gdd')<CR>
nmap <silent> de :call <SID>diffstop()<CR>
" }}}
" Arrow keys {{{
map <up> gk
map <down> gj
map <home> g<home>
map <end> g<end>
imap <up> <C-o>gk
imap <down> <C-o>gj
imap <home> <C-o>g<home>
imap <end> <C-o>g<end>
" }}}
" Hit <C-a> in insert mode after a bad paste (thanks absolon) {{{
inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi
" }}}
" Ctags {{{
nmap \t :silent !ctags -a %<CR><C-L>
" }}}
" Nopaste {{{
function s:nopaste(visual)
    let nopaste_services = $NOPASTE_SERVICES
    if &filetype == 'tex'
        let $NOPASTE_SERVICES = "Mathbin ".$NOPASTE_SERVICES
    endif

    if a:visual
        silent exe "normal gv!nopaste\<CR>"
    else
        let pos = getpos('.')
        silent exe "normal gg!Gnopaste\<CR>"
    endif
    silent normal "+yy
    let @* = @+
    silent undo
    if a:visual
        normal gv
    else
        call setpos('.', pos)
    endif
    let $NOPASTE_SERVICES = nopaste_services
    echo @+
endfunction
nmap <silent> \p :call <SID>nopaste(0)<CR>
vmap <silent> \p :<C-U>call <SID>nopaste(1)<CR>
" }}}
" Miscellaneous {{{
" have Y behave analogously to D rather than to dd
nmap Y y$

" easily cancel hitting \ once
nnoremap \\ \

" clear the search highlight
nmap <silent>\/ :nohl<CR>

" toggle line numbers
nmap <silent>\n :set invnumber<CR>

" manually resync the syntax highlighting
nmap <silent>\s :syntax sync fromstart<CR>
" }}}
" }}}
" Plugin settings {{{
" Enhanced Commentify {{{
let g:EnhCommentifyBindInInsert = 'No'
let g:EnhCommentifyRespectIndent = 'Yes'
" }}}
" Rainbow {{{
let g:rainbow = 1
let g:rainbow_paren = 1
let g:rainbow_brace = 1
" just loading this directly from the plugin directory fails because language
" syntax files override the highlighting
" using BufWinEnter because that is run after modelines are run (so it catches
" modelines which update highlighting)
autocmd BufWinEnter * runtime plugin/rainbow_paren.vim
" }}}
" Taglist {{{
let s:session_file = './.tlist_session'
let TlistIncWinWidth = 0
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Horiz_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Close_On_Select = 1
let Tlist_Display_Prototype = 1
nnoremap <silent> <F8> :TlistToggle<CR>
" if the current file isn't below the current directory, :. doesn't modify %
if file_readable(s:session_file) && expand("%:.") !~ '^/'
    autocmd VimEnter * TlistDebug | exec 'TlistSessionLoad ' . s:session_file
    autocmd VimLeave * call delete(s:session_file) | exec 'TlistSessionSave ' . s:session_file
endif
" }}}
" SuperTab {{{
let g:SuperTabMidWordCompletion = 0
let g:SuperTabDefaultCompletionType = 'context'
" }}}
" Textobj {{{
let g:Textobj_defs = [
   \['/', 'Textobj_paired', '/'],
   \['f', 'Textobj_fold'],
   \[',', 'Textobj_arg'],
\]
" }}}
" Foldtext {{{
let g:Foldtext_enable = 1
let g:Foldtext_tex_enable = 1
let g:Foldtext_cpp_enable = 1
let g:Foldtext_perl_enable = 1
" }}}
" }}}
