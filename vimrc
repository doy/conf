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

" don't move the cursor to the start of the line when changing buffers
set nostartofline
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

" hide the mouse in the gui while typing
set mousehide

" fold only when I ask for it damnit!
set foldmethod=marker

" Language specific features {{{
" Bash {{{
" I use bash
let g:is_bash=1
" }}}
" C/C++ {{{
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

" add : as a file-name character (allow gf to work with http://foo.bar/)
set isfname+=:

" tab completion stuff for the command line
set wildmode=longest,list,full

" don't jump to search results until i actually do the search
set noincsearch

" always make the help window cover the entire screen
set helpheight=9999

if has("autocmd") && exists("+omnifunc")
    autocmd FileType *
                \   if &omnifunc == "" |
                \           setlocal omnifunc=syntaxcomplete#Complete |
                \   endif
endif

let mapleader = ';'

if exists("+undofile")
    set undofile
endif
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

" send more data to the terminal in a way that makes the screen update faster
set ttyfast
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
" }}}
" Colors {{{
" default colorscheme {{{
if has("gui_running")
    colorscheme torte
else
    colorscheme peachpuff
endif
" }}}
" word completion menu {{{
highlight Pmenu      ctermfg=grey  ctermbg=darkblue guifg=grey guibg=darkblue
highlight PmenuSel   ctermfg=red   ctermbg=darkblue guifg=red  guibg=darkblue
highlight PmenuSbar  ctermbg=cyan                   guibg=cyan
highlight PmenuThumb ctermfg=red                    guifg=red

highlight WildMenu   ctermfg=grey  ctermbg=darkblue guifg=grey guibg=darkblue
" }}}
" folding {{{
highlight Folded ctermbg=black ctermfg=darkgreen guibg=black guifg=green
" }}}
" hlsearch {{{
highlight Search NONE ctermfg=red guifg=red
" }}}
" color end of line whitespace {{{
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red
" }}}
" fonts {{{
if has('win32') || has('win64') || has('win32unix')
    set guifont=Lucida_Console
elseif has('unix')
    set guifont=Monospace\ 8
endif
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
" }}}
" Auto +x {{{
au BufWritePost *.{sh,pl} silent exe "!chmod +x %"
" }}}
" Update ctags after writing {{{
autocmd BufWritePost * if filereadable('tags') | silent exe "!ctags -a %" | redraw | endif
" }}}
" Misc {{{
autocmd BufWritePost .conkyrc silent exe "!killall -HUP conky"
autocmd QuickFixCmdPost * copen 3
" }}}
" }}}
" Remappings {{{
" vcs convenience mappings {{{
" darcs {{{
nmap <Leader>da  :execute 'w  <bar> !darcs add %'<CR>
nmap <Leader>dr  :execute 'w  <bar> !darcs record %'<CR>
nmap <Leader>dR  :execute 'wa <bar> !darcs record'<CR>
nmap <Leader>dm  :execute 'w  <bar> !darcs amend-record %'<CR>
nmap <Leader>dM  :execute 'wa <bar> !darcs amend-record'<CR>
nmap <Leader>dn  :execute 'w  <bar> !darcs whatsnew % <bar> less'<CR>
nmap <Leader>dN  :execute 'wa <bar> !darcs whatsnew   <bar> less'<CR>
nmap <Leader>dd  :execute 'w  <bar> !darcs diff -u %  <bar> less'<CR>
nmap <Leader>dD  :execute 'wa <bar> !darcs diff -u    <bar> less'<CR>
nmap <Leader>dc  :execute '!darcs changes %           <bar> less'<CR>
nmap <Leader>dC  :execute '!darcs changes             <bar> less'<CR>
nmap <Leader>dl  :execute '!darcs query manifest      <bar> less'<CR>
nmap <Leader>dt  :execute '!darcs tag'<CR>
nmap <Leader>dp  :execute '!darcs push'<CR>
nmap <Leader>du  :execute '!darcs unrecord'<CR>
nmap <Leader>db  :execute "w <bar> :execute '!darcs revert %'   <bar> :silent execute 'e'"<CR>
nmap <Leader>dB  :execute "w <bar> :execute '!darcs unrevert %' <bar> :silent execute 'e'"<CR>
" }}}
" git {{{
nmap <Leader>ga  :execute 'w  <bar> !git add %'<CR>
nmap <Leader>gr  :execute 'w  <bar> !git add -p % && git commit'<CR>
nmap <Leader>gR  :execute 'wa <bar> !git add -p && git commit'<CR>
nmap <Leader>gm  :execute 'w  <bar> !git add -p % && git commit --amend'<CR>
nmap <Leader>gM  :execute 'wa <bar> !git add -p && git commit --amend'<CR>
nmap <Leader>gd  :execute 'w  <bar> !git diff %'<CR>
nmap <Leader>gD  :execute 'wa <bar> !git diff'<CR>
nmap <Leader>gc  :execute '!git commit'<CR>
nmap <Leader>gl  :execute '!git log'<CR>
nmap <Leader>gp  :execute '!git push'<CR>
nmap <Leader>gP  :execute '!git pushall'<CR>
nmap <Leader>gu  :execute '!git reset'<CR>
nmap <Leader>gU  :execute '!git reset --hard'<CR>
nmap <Leader>gs  :execute "wa <bar> :execute '!git stash'       <bar> :silent execute 'e'"<CR>
nmap <Leader>gB  :execute "wa <bar> :execute '!git stash apply' <bar> :silent execute 'e'"<CR>
"nmap <Leader>gb  :execute "w <bar> :execute '!darcs revert %'   <bar> :silent execute 'e'"<CR>
"nmap <Leader>gB  :execute "w <bar> :execute '!darcs unrevert %' <bar> :silent execute 'e'"<CR>
"nmap <Leader>gn  :execute 'w  <bar> !git diff % <bar> less'<CR>
"nmap <Leader>gN  :execute 'wa <bar> !git diff   <bar> less'<CR>
"nmap <Leader>gt  :execute '!git tag'<CR>
"nmap <Leader>gC  :execute '!git commit'<CR>
" }}}
" }}}
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
let s:diffwindow = 0
function s:diffstart(read_cmd)
    if s:diffwindow != 0
        return
    endif
    let s:foldmethod = &foldmethod
    let s:foldenable = &foldenable
    let filetype = &filetype
    vert new
    let s:diffwindow = winnr()
    set bt=nofile
    try
        exe a:read_cmd
    catch /.*/
        echohl ErrorMsg
        echo v:exception
        echohl NONE
        call s:diffstop()
        return
    endtry
    let &filetype = filetype
    diffthis
    wincmd p
    diffthis
    " why does this not happen automatically?
    normal zM
endfunction
function s:diffstop()
    if s:diffwindow == 0
        return
    endif
    diffoff!
    exe s:diffwindow . 'wincmd w'
    bdelete
    let &foldmethod = s:foldmethod
    let &foldenable = s:foldenable
    if &foldenable
        normal zv
    endif
    let s:diffwindow = 0
endfunction
function s:vcs_orig(file)
    " XXX: would be nice to use a:file rather than # here...
    let dir = expand('#:p:h')
    if filewritable(dir . '/.svn') == 2
        return system('svn cat ' . a:file)
    elseif filewritable(dir . '/CVS') == 2
        return system("AFILE=" . a:file . "; MODFILE=`tempfile`; DIFF=`tempfile`; cp $AFILE $MODFILE && cvs diff -u $AFILE > $DIFF; patch -R $MODFILE $DIFF 2>&1 > /dev/null && cat $MODFILE; rm $MODFILE $DIFF")
    elseif finddir('_darcs', dir . ';') =~ '_darcs'
        return system('darcs show contents ' . a:file)
    elseif finddir('.git', dir . ';') =~ '.git'
        return system('git show HEAD:' . a:file)
    else
        throw 'No VCS directory found'
    endif
endfunction
nmap <silent> ds :call <SID>diffstart('read # <bar> normal ggdd')<CR>
nmap <silent> dc :call <SID>diffstart('call append(0, split(s:vcs_orig(expand("#")), "\n", 1)) <bar> normal Gdddd')<CR>
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
nmap <Leader>t :silent !ctags -a %<CR><C-L>
nmap <CR> <C-]>
nmap <BS> <C-T>
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
nmap <silent> <Leader>p :call <SID>nopaste(0)<CR>
vmap <silent> <Leader>p :<C-U>call <SID>nopaste(1)<CR>
" }}}
" better version of keywordprg {{{
function Help(visual, iskeyword, command)
    let iskeyword = &iskeyword
    for kw in a:iskeyword
        exe 'set iskeyword+=' . kw
    endfor
    if a:visual
        let oldreg = @a
        normal `<"ay`>gv
        let word = @a
        let @a = oldreg
    else
        let word = expand('<cword>')
    endif
    let &iskeyword = iskeyword
    exe &helpheight . 'new'
    set modifiable
    exe 'call ' . a:command . '("' . word . '")'
    set bt=nofile
    set nobuflisted
    set nomodifiable
endfunction
function s:man(word)
    exe 'silent read! man -P"col -b" ' . a:word
    normal ggdd
    set ft=man
endfunction
nmap <silent>K :call Help(0, [], '<SID>man')<CR>
vmap <silent>K :call Help(1, [], '<SID>man')<CR>
" }}}
" Miscellaneous {{{
" have Y behave analogously to D rather than to dd
nmap Y y$

" easily cancel hitting the leader key once
nnoremap <Leader><Leader> <Leader>

" clear the search highlight
nmap <silent><Leader>/ :nohl<CR>

" toggle line numbers
nmap <silent><Leader>n :set invnumber<CR>

" manually resync the syntax highlighting
nmap <silent><Leader>s :syntax sync fromstart<CR>
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
" Skeletons {{{
let g:Skeleton_patterns = [
    \'*.pl',
    \'*.pm',
    \'*.cpp',
    \'*.c',
    \'*.tex',
    \'*.t',
    \'Makefile',
    \'Makefile.PL'
\]
" }}}
" }}}
