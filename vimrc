" based on Eidolos's .vimrc, at http://sartak.org/conf/vimrc

" pathogen {{{
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
" }}}
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

" don't move the cursor to the start of the line when changing buffers
set nostartofline

" call CursorHold autocommands (and write swap files to disk) more often
set updatetime=2000

" strip leading comment characters when joining multiline comments
set formatoptions+=j
" }}}
" Display {{{
" color!
syntax on

" lines, cols in status line
set ruler

" display more information in the ruler
set rulerformat=%26(%y%r%m\ (%n)\ %.7l,%.7c\ %=\ %P%)

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" don't display the current mode, since airline does that
set noshowmode

" a - terse messages (like [+] instead of [Modified]
" o - don't show both reading and writing messages if both occur at once
" t - truncate file names
" T - truncate messages rather than prompting to press enter
" W - don't show [w] when writing
" I - no intro message when starting vim fileless
set shortmess=aotTWI

" status line
set laststatus=2

" display as much of the last line as possible if it's really long
" also display unprintable characters as hex
set display+=lastline,uhex

" give three lines of context when moving the cursor around
set scrolloff=3

" don't redraw the screen during macros etc (NetHack's runmode:teleport)
set lazyredraw

" highlight all matches, we'll see if this works with a different hilight
set hlsearch

" highlight matching parens for .1s
set showmatch
set matchtime=1

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

" visually indicate wrapped lines
set showbreak=>

" enable concealing
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

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

" when doing tab completion, ignore files that match any of these
set wildignore+=*.o,.git/*,.svn/*,blib/*
" exclusions {{{
function! s:set_excludes()
    if filereadable("dist.ini")
        for line in readfile("dist.ini", '', 10)
            let name = matchstr(line, '\s*name\s*=\s*\zs.*')
            if name != ""
                exe 'set wildignore+=' . name . '-*/*'
                break
            endif
        endfor
    endif
endfunction
autocmd BufReadPost * call <SID>set_excludes()
call <SID>set_excludes()
" }}}

" tab completions should ignore case
if exists("+wildignorecase")
    set wildignorecase
endif

" remember lotsa fun stuff
set viminfo=!,'1000,f1,/1000,:1000,<1000,@1000,h,n~/.viminfo

" more stuff to remember
set history=1000

" add : as a filename character (allow gf to work with http://foo.bar/)
set isfname+=:

" tab completion stuff for the command line
set wildmode=longest,list,full

" always make the help window cover the entire screen
set helpheight=9999

" fall back to syntax completion when possible
if has("autocmd") && exists("+omnifunc")
    autocmd FileType *
                \   if &omnifunc == "" |
                \           setlocal omnifunc=syntaxcomplete#Complete |
                \   endif
endif

" ; is easier to reach than \
let mapleader = ';'
let maplocalleader = ';'

" enable persistent undo
if has("persistent_undo")
    set undofile
    set undodir=~/.vim/data/undo
endif

" case insensitive searching, unless i type a capital letter
set ignorecase
set smartcase
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
" more importantly, wraps lines at the terminal level so that copying a single
" line that spans multiple screen lines works properly
set ttyfast
" }}}
" Indentation {{{
" normal sized tabs!
set tabstop=8

" set to what i like (see #2 in :help tabstop)
set shiftwidth=4

" if it looks like a tab, we can delete it like a tab
set softtabstop=-1

" no tabs! spaces only..
set expandtab

" < and > will hit indentation levels instead of always -4/+4
set shiftround

" new line has indentation equal to previous line
set autoindent

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
    set background=light
    set t_Co=256
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
" conflict markers {{{
match ErrorMsg '^\(<\||\|=\|>\)\{7\}\([^=].\+\)\?$'
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
\  if &filetype != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
\    exe "normal g`\"" |
\  endif
" }}}
" Update ctags after writing {{{
autocmd BufWritePost * if filereadable('tags') | silent exe "!ctags -a %" | redraw | endif
" }}}
" Prompt to create directories if they don't exist {{{
autocmd BufNewFile * :call <SID>ensure_dir_exists()
function! s:ensure_dir_exists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call <SID>ask_quit("Directory '" . required_dir . "' doesn't exist.", "&Create it?")

        try
            call mkdir( required_dir, 'p' )
        catch
            call <SID>ask_quit("Can't create '" . required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction
function! s:ask_quit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        exit
    endif
endfunction
" }}}
" Try harder to keep syntax highlighting in sync {{{
autocmd BufEnter,CursorHold,CursorHoldI * syntax sync fromstart
" }}}
" Update zsh history when editing a new file - see 'vim' wrapper in .zshrc {{{
if $SHELL =~ 'zsh' && exists('g:_zsh_hist_fname')
    let s:initial_files = {}

    autocmd VimEnter * call <SID>init_zsh_hist()
    autocmd BufNewFile,BufRead * call <SID>zsh_hist_append()
    autocmd BufDelete * call <SID>remove_initial_file(expand("<afile>"))

    function! s:remove_initial_file (file)
        if has_key(s:initial_files, a:file)
            unlet s:initial_files[a:file]
        endif
    endfunction
    function! s:get_buffer_list_text ()
        redir => output
        ls!
        redir END
        return output
    endfunction
    function! s:get_buffer_list ()
        silent let output = <SID>get_buffer_list_text()
        let buffer_list = []
        for buffer_desc in split(output, "\n")
            let buffer_bits = split(buffer_desc, '"')
            call add(buffer_list, buffer_bits[1])
        endfor
        return buffer_list
    endfunction
    function! s:init_zsh_hist ()
        for fname in <SID>get_buffer_list()
            let s:initial_files[fname] = 1
        endfor
        call delete(g:_zsh_hist_fname)
    endfunction
    function! s:zsh_hist_append ()
        let to_append = expand("%:~:.")
        " XXX gundo sets buftype too late to be caught by this... this
        " is broken, but not sure what a better fix is
        if &buftype == '' && to_append !~ "^__Gundo"
            if !has_key(s:initial_files, to_append)
                if filereadable(g:_zsh_hist_fname)
                    let hist = readfile(g:_zsh_hist_fname)
                else
                    let hist = []
                endif
                call add(hist, to_append)
                call writefile(hist, g:_zsh_hist_fname)
            endif
        endif
    endfunction
endif
" }}}
" start with the current fold open {{{
autocmd BufReadPost * normal zv
" }}}
" disable syntax highlighting for huge files (it's really slow) {{{
autocmd BufEnter * if line('$') > 20000 | syntax off | endif
" }}}
" Misc {{{
autocmd BufWritePost *conkyrc silent exe "!killall -HUP conky"
" }}}
" }}}
" Remappings {{{
" Keep the current selection when indenting (thanks cbus) {{{
xnoremap < <gv
xnoremap > >gv
" }}}
" F5 to :make {{{
noremap  <silent>M :<C-u>make<CR><CR><C-W>k
" }}}
" Painless spell checking (F11) {{{
function! s:spell()
    if !exists("s:spell_check") || s:spell_check == 0
        let s:spell_check = 1
        setlocal spell spelllang=en_us
    else
        let s:spell_check = 0
        setlocal spell spelllang=
    endif
endfunction
noremap  <silent><F11> :<C-u>call <SID>spell()<CR>
inoremap <silent><F11> <C-o>:call <SID>spell()<CR>
" }}}
" diff between current file and its original state {{{
let s:foldmethod = &foldmethod
let s:foldenable = &foldenable
let s:diffwindow = 0
function! s:diffstart(read_cmd)
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
        normal zv
    endif
    let s:diffwindow = 0
endfunction
function! s:vcs_orig(file)
    " XXX: would be nice to use a:file rather than # here...
    let dir = expand('#:p:h')
    if filewritable(dir . '/.svn') == 2
        return system('svn cat ' . a:file)
    elseif filewritable(dir . '/CVS') == 2
        return system("AFILE=" . a:file . "; MODFILE=`tempfile`; DIFF=`tempfile`; cp $AFILE $MODFILE && cvs diff -u $AFILE > $DIFF; patch -R $MODFILE $DIFF 2>&1 > /dev/null && cat $MODFILE; rm $MODFILE $DIFF")
    elseif finddir('_darcs', dir . ';') =~ '_darcs'
        return system('darcs show contents ' . a:file)
    elseif finddir('.git', dir . ';') =~ '.git'
        let prefix = system('git rev-parse --show-prefix')
        let prefix = substitute(prefix, '\n', '', 'g')
        let cmd = 'git show HEAD:'.prefix.a:file
        return system(cmd)
    else
        throw 'No VCS directory found'
    endif
endfunction
nnoremap <silent>ds :call <SID>diffstart('read # <bar> normal ggdd')<CR>
nnoremap <silent>dc :call <SID>diffstart('call append(0, split(s:vcs_orig(expand("#:.")), "\n", 1)) <bar> normal Gdddd')<CR>
nnoremap <silent>de :call <SID>diffstop()<CR>
" }}}
" Arrow keys {{{
noremap  <up>   gk
noremap  <down> gj
inoremap <up>   <C-o>gk
inoremap <down> <C-o>gj
" }}}
" Nopaste {{{
function! s:nopaste(visual)
    if a:visual
        silent exe "normal gv:!nopaste\<CR>"
    else
        let pos = getpos('.')
        silent exe "normal :%!nopaste\<CR>"
    endif
    silent normal "+yy
    let @* = @+
    silent undo
    " can't restore visual selection because that will overwrite "*
    if !a:visual
        call setpos('.', pos)
    endif
    echo @+
endfunction
nnoremap <silent><Leader>p :call <SID>nopaste(0)<CR>
xnoremap <silent><Leader>p :<C-U>call <SID>nopaste(1)<CR>
" }}}
" better version of keywordprg {{{
function! Help(visual, iskeyword, command)
    let iskeyword = &iskeyword
    for kw in a:iskeyword
        exe 'set iskeyword+=' . kw
    endfor
    if a:visual
        let oldreg = @a
        " XXX this seems to not include the end of the selection - why?
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
    try
        silent %s/\%x1b\[\d\+m//g
    catch /.*/
    endtry
    try
        silent %s/.\%x08//g
    catch /.*/
    endtry
    normal ggdd
    set bt=nofile
    set nobuflisted
    set nomodifiable
endfunction
function! s:man(word)
    exe 'silent read! man -Pcat ' . a:word
    set ft=man
endfunction
nnoremap <silent>K :call Help(0, [], '<SID>man')<CR>
xnoremap <silent>K :call Help(1, [], '<SID>man')<CR>
" }}}
" ;= to align = signs {{{
function! s:align_assignments()
    " Patterns needed to locate assignment operators...
    let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

    " Locate block of code to be considered (same indentation, no blanks)
    let indent_pat = '^' . matchstr(getline('.'), '^\s*') . '\S'
    let firstline  = search('^\%('. indent_pat . '\)\@!','bnW') + 1
    let lastline   = search('^\%('. indent_pat . '\)\@!', 'nW') - 1
    if lastline < 0
        let lastline = line('$')
    endif

    " Decompose lines at assignment operators...
    let lines = []
    for linetext in getline(firstline, lastline)
        let fields = matchlist(linetext, ASSIGN_LINE)
        call add(lines, fields[1:3])
    endfor

    " Determine maximal lengths of lvalue and operator...
    let op_lines = filter(copy(lines),'!empty(v:val)')
    let max_lval = max( map(copy(op_lines), 'strlen(v:val[0])') ) + 1
    let max_op   = max( map(copy(op_lines), 'strlen(v:val[1])'  ) )

    " Recompose lines with operators at the maximum length...
    let linenum = firstline
    for line in lines
        if !empty(line)
            let newline
            \    = printf("%-*s%*s%s", max_lval, line[0], max_op, line[1], line[2])
            call setline(linenum, newline)
        endif
        let linenum += 1
    endfor
endfunction
nnoremap <silent><Leader>= :call <SID>align_assignments()<CR>
" fix this to work in visual mode properly
"xnoremap <silent><Leader>= :call <SID>align_assignments()<CR>
" }}}
" ;i/;I/;a/;A/;o/;O for entering insert mode with paste set {{{
function! s:temporary_paste()
    setlocal paste
    augroup temporary_paste
        autocmd InsertLeave <buffer> setlocal nopaste | autocmd! temporary_paste
    augroup END
endfunction
nnoremap <silent>;i :call <SID>temporary_paste()<CR>i
nnoremap <silent>;I :call <SID>temporary_paste()<CR>I
nnoremap <silent>;a :call <SID>temporary_paste()<CR>a
nnoremap <silent>;A :call <SID>temporary_paste()<CR>A
nnoremap <silent>;o :call <SID>temporary_paste()<CR>o
nnoremap <silent>;O :call <SID>temporary_paste()<CR>O
" }}}
" keystroke reducers {{{
" tags
nnoremap <CR> <C-]>
nnoremap <BS> <C-T>
autocmd CmdWinEnter * nnoremap <buffer><CR> <CR>

" 'e' instead of 'c' for change
nnoremap e c
nnoremap E C

" 'r' instead of '^R' for redo
nnoremap r <C-r>

" buffer switching
nnoremap <silent>H :bp<CR>
nnoremap <silent>L :bn<CR>

" clear the search highlight
nnoremap <silent><Leader>/ :nohl<CR>

" easier commands
nnoremap , :
xnoremap , :
nnoremap ! :!
xnoremap ! :!

" writing, quitting
nnoremap <silent><Tab> :w<CR>
nnoremap <silent>\     :q<CR>
nnoremap <silent><C-D> :bd<CR>

" allow some commands to work regardless of keyboard mode
nmap <silent>) 0
nmap <Bar> \
" }}}
" Miscellaneous {{{
" have Y behave analogously to D rather than to dd
nnoremap Y y$

autocmd BufEnter * exe "nnoremap T :e " . expand('%')
" }}}
" }}}
" Plugin settings {{{
" matchit {{{
runtime macros/matchit.vim
" }}}
" tComment {{{
nmap ;x gcc
xmap ;x gc
let g:tcommentBlankLines = 0
" }}}
" Rainbow {{{
let g:rainbow = 1
let g:rainbow_paren = 1
let g:rainbow_brace = 1
" just loading this directly from the plugin directory fails because language
" syntax files override the highlighting
" using BufWinEnter because that is run after modelines are run (so it catches
" modelines which update highlighting)
autocmd BufWinEnter,FileType * runtime plugin/rainbow_paren.vim
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
" gundo {{{
if has("python")
    function! s:gundo()
        GundoToggle
    endfunction
    nnoremap <silent>U :silent call <SID>gundo()<CR>
    let g:gundo_help = 0
    let g:gundo_preview_bottom = 1
    let g:gundo_width = 30
    let g:gundo_auto_preview = 0
else
    let g:gundo_disable = 1
endif
" }}}
" signify {{{
let g:signify_vcs_list = [ 'git', 'svn' ]
let g:signify_disable_by_default = 1
nnoremap <silent>dv :SignifyToggle<CR>
" }}}
" startify {{{
let g:startify_files_number = 4
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = [
            \'!', '@', '#', '$', '%', '^', '&', '*', '(', ')'
            \]
let fortune = system('fortune -n200 -s ~/.fortune | grep -v -E "^$"')
let g:startify_custom_footer = [''] + map(split(fortune, '\n'), '"   ".v:val')
let g:startify_skiplist = ['^/usr/share/vim', '/.git/']
for file in [ '.gitignore', expand('~/.gitignore') ]
    if filereadable(file)
        for line in readfile(file)
            let line = substitute(line, '#.*', '', '')
            if line != ''
                call extend(g:startify_skiplist, map(glob(line, 1, 1), "substitute(v:val, '[~.*]', '\\\\&', 'g')"))
            endif
        endfor
    endif
endfor
" }}}
" unite {{{
let g:unite_data_directory = '~/.vim/data/unite'
let g:unite_source_rec_max_cache_files = 20000
let g:unite_enable_start_insert = 1
let g:unite_enable_short_source_names = 1
let g:unite_source_grep_max_candidates = 200
if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
                \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
                \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
endif
let rec_exclude = '\('
        \. '\(^\|/\)\.\|'
        \. '\~$\|'
        \. '\<\(node_modules\|blib\|nytprof\|project\|target\)\|'
        \. '\.\('
            \. 'o\|exe\|dll\|bak\|orig\|swp\|bs\|'
            \. 'png\|jpg\|gif\|pdf\|doc\|d\|vsprops\|pbxproj\|sln'
        \. '\)$'
    \. '\)'
if filereadable("dist.ini")
    let rec_exclude .= '\|^' . fnamemodify('.', ':p:h:t') . '-'
endif
call unite#custom#source('file_rec/async', 'ignore_pattern', rec_exclude)
call unite#custom#source('file_rec/async', 'converters', ['converter_relative_word'])
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
    nmap <silent><buffer> \       <Plug>(unite_exit)
    imap <silent><buffer> <Tab>   <Plug>(unite_select_next_line)
    imap <silent><buffer> <S-Tab> <Plug>(unite_select_previous_line)
    autocmd InsertLeave <buffer>  call feedkeys("\<Plug>(unite_exit)")
endfunction
nnoremap <silent>t :Unite -silent -profile-name=with_dir buffer file_rec/async<CR>
nnoremap <silent>& :Unite -silent grep:.<CR>
" }}}
" vimfiler {{{
let g:vimfiler_data_directory = '~/.vim/data/vimfiler'
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_execute_file_list = { "_": "vim" }
autocmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
    nmap <silent><buffer> \    <Plug>(vimfiler_exit)
    nmap <silent><buffer> <CR> <Plug>(vimfiler_edit_file)
endfunction
nnoremap <silent>c :VimFilerSimple -quit -explorer<CR>
" }}}
" bufferline {{{
let g:bufferline_echo = 0
let g:bufferline_rotate = 1
let g:bufferline_fixed_index = -2
" }}}
" neocomplete {{{
let g:neocomplete#data_directory = '~/.vim/data/neocomplete'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#sources#syntax#min_keyword_length = 4
let g:neocomplete#max_list = 4
let g:neocomplete#enable_fuzzy_completion = 0
let g:neocomplete#disable_auto_complete = 1
" see neosnippet config for the tab mapping
function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction
" }}}
" neosnippet {{{
let g:neosnippet#snippets_directory = '~/.vim/snippets'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }
imap <expr><Tab>
            \ neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ pumvisible() ?
                \ "\<C-n>" :
            \ <SID>check_back_space() ?
                \ "\<Tab>" :
                \ neocomplete#start_manual_complete()
imap <expr><S-Tab>
            \ neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ pumvisible() ?
                \ "\<C-p>" :
            \ <SID>check_back_space() ?
                \ "\<Tab>" :
                \ neocomplete#start_manual_complete()
smap <expr><Tab>
            \ neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ <SID>check_back_space() ?
                \ "\<Tab>" :
                \ neocomplete#start_manual_complete()
" }}}
" easymotion {{{
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_enter_jump_first = 1

map ff <Plug>(easymotion-fl)
omap ff <Plug>(easymotion-tl)

map fj <Plug>(easymotion-j)
map fk <Plug>(easymotion-k)
map fh <Plug>(easymotion-linebackward)
map fl <Plug>(easymotion-lineforward)

map f/ <Plug>(easymotion-fn)
omap f/ <Plug>(easymotion-tn)
map f? <Plug>(easymotion-Fn)
omap f? <Plug>(easymotion-Tn)
map fn <Plug>(easymotion-vim-n)
map fN <Plug>(easymotion-vim-N)
" }}}
" }}}
