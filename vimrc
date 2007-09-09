" vim:foldmethod=marker commentstring="%s

" General options {{{
" Miscellaneous {{{
" fuck vi! long live vim!
set nocompatible

" indentation FTW.. also plugins FTW! heh
filetype indent plugin on

" automatically flush to disk when using :make, etc.
set autowrite
"}}}
" Display {{{
" color!
syntax on

" lines, cols in status line
set ruler

" current mode in status line
set showmode

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" a - terse messages (like [+] instead of [Modified]
" t - truncate file names
" I - no intro message when starting vim fileless
set shortmess=atI

" no extra status lines
set laststatus=0

" display as much of the last line as possible if it's really long
" also display unprintable characters as hex
set display=lastline,uhex

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

" highlight advanced perl vars inside strings
let perl_extended_vars=1

" POD!
let perl_include_pod=1

" I generally don't want to have to space through things.. :)
set nomore
"}}}
" Improve power of commands {{{
" incremental search!
set incsearch

" make tilde (flip case) an operator
set tildeop

" backspace over autoindent, end of line (to join lines), and preexisting test
set backspace=indent,eol,start

" add the dictionary to tab completion
set dictionary=/usr/share/dict/words
set complete+=k

" tab completion in ex mode
set wildmenu

" when doing tab completion, ignore files with any of the following extensions
set wildignore+=.log,.out,.o

" remember lotsa fun stuff
set viminfo=!,'1000,f1,/1000,:1000,<1000,@1000,h,n~/.viminfo

" add : as a file-name character (mostly for Perl's mod::ules)
set isfname+=:
"}}}
" Make vim less whiny {{{
" :bn with a change in the current buffer? no prob!
set hidden

" no bells whatsoever
set vb t_vb=

" if you :q with changes it asks you if you want to continue or not
set confirm

" 100 milliseconds for escape timeout instead of 1000
set ttimeoutlen=100
"}}}
" Indentation {{{
" no-longer skinny tabs!
set tabstop=4

" set to the same as tabstop (see #4 in :help tabstop)
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

" figure out indent when ; is pressed
set cinkeys+=;

" align break with case in a switch
set cinoptions+=b1
"}}}
" Folding {{{
" fold only when I ask for it damnit!
set foldmethod=marker

" close a fold when I leave it
set foldclose=all
"}}}
" Tags {{{
set tags+='./.tags,.tags' " add .tags files
set tags+='./../tags,../tags,./../.tags,../.tags' " look in the level above
"}}}
"}}}

" Colors {{{
" miscellaneous {{{
set bg=light
" }}}
" word completion menu {{{
highlight Pmenu      ctermfg=grey  ctermbg=darkblue
highlight PmenuSel   ctermfg=red   ctermbg=darkblue
highlight PmenuSbar  ctermbg=cyan
highlight PmenuThumb ctermfg=red

highlight WildMenu ctermfg=grey ctermbg=darkblue
"}}}
" folding {{{
highlight Folded     ctermbg=black ctermfg=darkgreen
"}}}
" hlsearch {{{
highlight Search NONE ctermfg=lightred
"}}}
"}}}

" Autocommands {{{
" When editing a file, always jump to the last cursor position {{{
autocmd BufReadPost *
\  if line("'\"") > 0 && line("'\"") <= line("$") |
\    exe "normal g`\"" |
\  endif
"}}}
" Skeletons {{{
autocmd BufNewFile *.pl silent 0read ~/.vim/skeletons/perl.pl     | normal G
autocmd BufNewFile *.pm silent 0read ~/.vim/skeletons/perl.pm     | normal G3k
autocmd BufNewFile *.c  silent 0read ~/.vim/skeletons/c.c         | normal 4j$
autocmd BufNewFile *.hs silent 0read ~/.vim/skeletons/haskell.hs  | normal Gk$
"}}}
" Auto +x {{{
au BufWritePost *.sh !chmod +x %
au BufWritePost *.pl !chmod +x %
"}}}
" Automatically invoke darcs record on writing vimrc {{{
autocmd BufWritePost ~/.vimrc !cd /home/sartak/devel/conf/ && darcs record
autocmd BufWritePost ~/devel/conf/vimrc !cd /home/sartak/devel/conf/ && darcs record
"}}}
" Perl {{{
autocmd FileType perl setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType perl setlocal errorformat=%f:%l:%m
autocmd FileType perl setlocal keywordprg=perldoc\ -f
"}}}
"}}}

" Insert-mode remappings/abbreviations {{{
" Hit <C-a> in insert mode after a bad paste (thanks absolon) {{{
inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi
"}}}
" Words I misspell.. {{{
iabbrev lamdba lambda
"}}}

" Normal-mode remappings {{{
" spacebar (in command mode) inserts a single character before the cursor
nmap <Space> i <Esc>r

" have Y behave analogously to D rather than to dd
nmap Y y$

nnoremap \\ \
nmap \/ :nohl<CR>
nmap \s :syntax sync fromstart<CR>
nmap \m :set syn=mason<CR>:syntax sync fromstart<CR>
nmap \n :set invnumber<CR>
nmap \c :make<CR>

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
nmap \db  :execute "w <bar> :execute '!darcs revert %'   <bar> :execute 'e'"<CR>
nmap \dB  :execute "w <bar> :execute '!darcs unrevert %' <bar> :execute 'e'"<CR>
"}}}

" testing mappings
autocmd FileType perl nnoremap \t :execute 'wa <bar> !prove -l t 1>/dev/null'<CR>
autocmd FileType perl nnoremap \T :execute 'wa <bar> !prove -lv t'<CR>

nmap <Right> :bn<CR>
nmap <Left>  :bp<CR>

autocmd FileType help nnoremap <CR> <C-]>
autocmd FileType help nnoremap <BS> <C-T>

" damnit cbus, you've won me over
vnoremap < <gv
vnoremap > >gv
" Make the tab key useful {{{
function TabWrapper()
  if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-N>"
  else
    return "\<C-N>"
  endif
endfunction
imap <Tab> <C-R>=TabWrapper()<CR>
"}}}
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
imap <F11> <C-o>:<BS>call <SID>spell()<CR>
"}}}
"}}}

" Text object ('i,' and 'a,') for function parameters {{{
" Notes:
" * "i," can't be used to select several parameters with several uses of
" "i," ; use "a," instead (-> va,a,a,). This is because of single
" letter parameters.
" However, "v2i," works perfectly.
" * Vim7+ only
" * The following should be resistant to &magic, and other mappings
onoremap <silent> i, :<c-u>call <sid>SelectParam(1,0)<cr>
xnoremap <silent> i, :<c-u>call <sid>SelectParam(1,1)<cr><esc>gv
onoremap <silent> a, :<c-u>call <sid>SelectParam(0,0)<cr>
xnoremap <silent> a, :<c-u>call <sid>SelectParam(0,1)<cr><esc>gv

function! s:SelectParam(inner, visual)
 let pos = getpos('.')
 if a:visual ==1 && s:CurChar("'>") =~ '[(,]'
   normal! gvl
 else
   let b = searchpair('\V(\zs','\V,\zs','\V)','bcW','s:Skip()')
   if 0 == b
     throw "Not on a parameter"
   endif
   normal! v
 endif
 let cnt = v:count <= 0 ? 1 : v:count

 while cnt > 0
   let cnt -= 1
   let e = searchpair('\V(', '\V,','\V)', 'W','s:Skip()')
   if 0 == e
     exe "normal! \<esc>"
     call setpos('.', pos)
     throw "Not on a parameter2"
   endif
   if cnt > 0
     normal! l
   endif
 endwhile
 if a:inner == 1
   normal! h
 endif
endfunction

function! s:CurChar(char)
 let c = getline(a:char)[col(a:char)-1]
 return c
endfunction

func! s:Skip()
 return synIDattr(synID(line('.'), col('.'), 0),'name') =~?
       \ 'string\|comment\|character\|doxygen'
endfun
" }}}

" Plugin configuration {{{
" Rainbowy parens, braces, and brackets {{{
let g:rainbow         = 1
let g:rainbow_nested  = 1
let g:rainbow_paren   = 1
let g:rainbow_brace   = 1
let g:rainbow_bracket = 1
"autocmd BufReadPost * source $HOME/.vim/rainbow_paren.vim
"autocmd BufNewFile  * source $HOME/.vim/rainbow_paren.vim
"}}}
" YankRing {{{
"let g:yankring_n_keys = 'yy,dd,cc,yw,dw,cw,ye,de,ce,yE,dE,cE,yiw,diw,ciw,yaw,daw,caw,y$,d$,c$,Y,D,C,yG,dG,cG,ygg,dgg,cgg,yi{,di{,ci{,ya{,da{,ca{,yip,dip,cip,yap,dap,cap,yi(,di(,ci(,ya(,da(,ca(,yi/,di/,ci/,ya/,da/,ca/,yi[,di[,ci[,ya[,da[,ca[,yW,dW,cW,yit,dit,cit,yat,dat,cat,yi<,di<,ci<,ya<,da<,ca<'
let g:yankring_n_keys = 'yy,dd,yw,dw,ye,de,yE,dE,yiw,diw,yaw,daw,y$,d$,Y,D,yG,dG,ygg,dgg,yi{,di{,ya{,da{,yip,dip,yap,dap,yi(,di(,ya(,da(,yi/,di/,ya/,da/,yi[,di[,ya[,da[,yW,dW,yit,dit,yat,dat,yi<,di<,ya<,da<'

function! YRRunAfterMaps()
    nnoremap <silent> Y :YRYankCount 'y$'<CR>
endfunction
" }}}
"}}}
" }}}

