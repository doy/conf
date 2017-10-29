" options {{{
" persistence {{{
set history=10000
if has("persistent_undo")
    set undofile
    set undodir=~/.cache/vim/undo
endif
" }}}
" buffers {{{
set autoread
set autowrite
set confirm
set hidden
set nostartofline
" }}}
" display {{{
set display+=lastline,uhex
set lazyredraw
set linebreak
set report=0
set scrolloff=3
set showbreak=>
set showcmd
if has('conceal')
    set conceallevel=2
endif
" }}}
" editing {{{
set autoindent
set backspace=indent,eol,start
set cinoptions+=:0,l1,g0,(0,W1s
set expandtab
set formatoptions+=j
set nojoinspaces
set shiftround
set shiftwidth=4
set softtabstop=-1
" }}}
" command mode {{{
set wildignore+=*.o,.git/*,.svn/*,blib/*
set wildmenu
set wildmode=longest,list,full
if exists("+wildignorecase")
    set wildignorecase
endif
" }}}
" search {{{
set hlsearch
set ignorecase
set smartcase
" }}}
" terminal stuff {{{
set ttimeoutlen=50
set ttyfast
set t_vb=
set visualbell
" }}}
" }}}
" colors {{{
" general {{{
syntax on
set background=light
set t_Co=256
" }}}
" recolorings {{{
highlight Folded ctermfg=darkgreen ctermbg=black guifg=green guibg=black
highlight Search NONE ctermfg=red guifg=red
" }}}
" highlight end of line whitespace {{{
augroup eolws
    autocmd!
    autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
    autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
augroup END
highlight EOLWS ctermbg=red guibg=red
" }}}
" highlight diff conflict markers {{{
match ErrorMsg '^\(<\||\|=\|>\)\{7\}\([^=].\+\)\?$'
" }}}
" }}}
" hooks {{{
" general {{{
augroup vimrc
    autocmd!
augroup END
" }}}
" When editing a file, always jump to the last cursor position {{{
autocmd vimrc BufReadPost * if line("'\"") <= line("$") | exe "normal! g`\"" | endif
" }}}
" }}}
" bindings {{{
" general {{{
let g:mapleader = ';'
let g:maplocalleader = ';'
" }}}
" keep the current selection when indenting {{{
xnoremap < <gv
xnoremap > >gv
" }}}
" M to :make {{{
noremap  <silent>M :<C-u>make<CR><CR><C-W>k
" }}}
" F11 for spell checking {{{
noremap  <silent><expr><F11> &spell ? ":\<C-u>setlocal nospell\<CR>" : ":\<C-u>setlocal spell\<CR>"
inoremap <silent><expr><F11> &spell ? "\<C-o>:setlocal nospell\<CR>" : "\<C-o>:setlocal spell\<CR>"
" }}}
" arrow keys {{{
noremap  <up>   gk
noremap  <down> gj
inoremap <up>   <C-o>gk
inoremap <down> <C-o>gj
" }}}
" editing binary files {{{
nnoremap <C-B> :%!xxd<CR>
nnoremap <C-R> :%!xxd -r<CR>
" }}}
" tab for completion {{{
inoremap <expr> <Tab> strpart(getline('.'), 0, col('.')-1) =~ '^\s*$' ? "\<Tab>" : "\<C-n>"
inoremap <S-Tab> <C-p>
" }}}
" easier tag traversal {{{
nnoremap <CR> <C-]>
nnoremap <BS> <C-T>
autocmd CmdWinEnter * nnoremap <buffer><CR> <CR>
" }}}
" buffer switching {{{
nnoremap <silent>H :bp<CR>
nnoremap <silent>L :bn<CR>
" }}}
" fixups for my keyboard remappings {{{
nmap <silent>) 0
nmap <silent>g) g0
nmap <Bar> \
" }}}
" miscellaneous {{{
nnoremap e c
nnoremap E C
nnoremap r <C-r>
nnoremap Y y$
nnoremap , :
xnoremap , :
nnoremap ! :!
xnoremap ! :!
autocmd vimrc BufEnter * exe "nnoremap T :e " . expand('%')
nnoremap <silent><Leader>/ :nohl<CR>
nnoremap <silent><Tab>     :w<CR>
nnoremap <silent>\         :q<CR>
nnoremap <silent><C-D>     :bd<CR>
" }}}
" }}}
" plugin configuration {{{
" general {{{
filetype indent plugin on
" }}}
" ale {{{
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_history_enabled = 0
let g:ale_history_log_output = 0
" }}}
" airline
" commentary {{{
map <silent><Leader>x :Commentary<CR>
" }}}
" denite {{{
autocmd vimrc VimEnter * call denite#custom#map('insert', '<Tab>', '<denite:move_to_next_line>')
autocmd vimrc VimEnter * call denite#custom#map('insert', '<S-Tab>', '<denite:move_to_previous_line>')
autocmd vimrc VimEnter * call denite#custom#source('line', 'sorters', [])
if executable('ag')
    autocmd vimrc VimEnter * call denite#custom#var('file_rec', 'command', ['ag', '--hidden', '-l', '.'])
    autocmd vimrc VimEnter * call denite#custom#var('grep', 'command', ['ag'])
    autocmd vimrc VimEnter * call denite#custom#var('grep', 'default_opts', ['--hidden'])
    autocmd vimrc VimEnter * call denite#custom#var('grep', 'recursive_opts', [])
    autocmd vimrc VimEnter * call denite#custom#var('grep', 'pattern_opt', [])
    autocmd vimrc VimEnter * call denite#custom#var('grep', 'separator', [])
endif
nnoremap <silent>t :Denite -direction=dynamictop buffer file_rec<CR>
nnoremap <silent>b :Denite -direction=dynamictop buffer<CR>
nnoremap <silent>ff :Denite -direction=dynamictop grep:.::!<CR>
nnoremap <silent>fh :Denite -direction=dynamictop help<CR>
nnoremap <silent>ft :Denite -direction=dynamictop filetype<CR>
nnoremap <silent>f/ :Denite -direction=dynamictop line<CR>
" }}}
" gundo {{{
if has("python")
    nnoremap <silent>U :silent GundoToggle<CR>
    let g:gundo_help = 0
    let g:gundo_preview_bottom = 1
else
    let g:gundo_disable = 1
endif
" }}}
" multiple-cursors
" neosnippet {{{
let g:neosnippet#snippets_directory = '~/.vim/snippets'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

let g:i_tab = maparg("<Tab>", "i", 0, 1)
let g:i_stab = maparg("<S-Tab>", "i", 0, 1)
let g:s_tab = maparg("<Tab>", "s", 0, 1)
imap <expr><Tab>
            \ neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" :
                \ g:i_tab["expr"] ? eval(g:i_tab["rhs"]) : g:i_tab["rhs"]
imap <expr><S-Tab>
            \ neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" :
                \ g:i_stab["expr"] ? eval(g:i_stab["rhs"]) : g:i_stab["rhs"]
smap <expr><Tab>
            \ neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" :
                \ g:s_tab["expr"] ? eval(g:s_tab["rhs"]) : g:s_tab["rhs"]
" }}}
" rainbow {{{
let g:rainbow = 1
let g:rainbow_paren = 1
let g:rainbow_brace = 1
" }}}
" startify {{{
let g:startify_list_order = ['dir', 'bookmarks', 'commands']
let g:startify_files_number = 7
let g:startify_commands = [
    \ {'t': ['Open file', 'Denite -direction=dynamictop buffer file_rec']},
    \ {'ff': ['Grep', 'Denite -direction=dynamictop grep:.::!']},
    \ {'fh': ['Help', 'Denite -direction=dynamictop help']},
    \ ]
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = [
            \'!', '@', '#', '$', '%', '^', '&', '*', '(', ')'
            \]
let g:startify_custom_header = []
let s:fortune = system('fortune -n200 -s ~/.fortune | grep -v -E "^$"')
let g:startify_custom_footer = [''] + map(split(s:fortune, '\n'), '"   ".v:val')
let g:startify_skiplist = ['^/usr/share/vim', '/.git/']
for s:file in [ '.gitignore', expand('~/.gitignore') ]
    if filereadable(s:file)
        for s:line in readfile(s:file)
            let s:line = substitute(s:line, '#.*', '', '')
            if s:line != '' && s:line[0] != '!'
                let s:line = substitute(s:line, "[~.]", "\\\\&", 'g')
                let s:line = substitute(s:line, "\\*\\*", ".*", 'g')
                let s:line = substitute(s:line, "\\*", "[^/]*", 'g')
                let s:line = substitute(s:line, "?", ".", 'g')
                call add(g:startify_skiplist, s:line)
            endif
        endfor
    endif
endfor
" }}}
" textobj {{{
let g:Textobj_defs = [
   \['/', 'Textobj_paired', '/'],
   \['\|', 'Textobj_paired', '\|'],
\]
" }}}
" Load plugins that don't use vim's format {{{
runtime macros/matchit.vim
" just loading this directly from the plugin directory fails because language
" syntax files override the highlighting
" using BufWinEnter because that is run after modelines are run (so it catches
" modelines which update highlighting)
autocmd BufWinEnter,FileType * runtime plugin/rainbow_paren.vim
" }}}
" }}}
" things that should be plugins {{{
" update zsh history when editing a new file - see 'vim' wrapper in .zshrc {{{
if $SHELL =~# 'zsh' && exists('g:_zsh_hist_fname')
    let s:initial_files = {}

    augroup zshhistory
        autocmd!
        autocmd VimEnter * call <SID>init_zsh_hist()
        autocmd BufNewFile,BufRead * call <SID>zsh_hist_append()
        autocmd BufDelete * call <SID>remove_initial_file(expand("<afile>"))
        autocmd VimLeave * call <SID>reorder_zsh_hist()
    augroup END

    function! s:remove_initial_file (file)
        if has_key(s:initial_files, a:file)
            unlet s:initial_files[a:file]
        endif
    endfunction
    function! s:get_buffer_list_text ()
        redir => l:output
        ls!
        redir END
        return l:output
    endfunction
    function! s:get_buffer_list ()
        silent let l:output = <SID>get_buffer_list_text()
        let l:buffer_list = []
        for l:buffer_desc in split(l:output, "\n")
            let l:name = bufname(str2nr(l:buffer_desc))
            if l:name != ""
                call add(l:buffer_list, l:name)
            endif
        endfor
        return l:buffer_list
    endfunction
    function! s:init_zsh_hist ()
        for l:fname in <SID>get_buffer_list()
            let s:initial_files[l:fname] = 1
            call histadd(":", "e " . l:fname)
        endfor
        call delete(g:_zsh_hist_fname)
    endfunction
    function! s:zsh_hist_append ()
        let l:to_append = expand("%:~:.")
        " XXX these set buftype too late to be caught by this...
        " this is broken, but not sure what a better fix is
        if &buftype == '' && l:to_append !~# '^\(__Gundo\|Startify\|\[denite\]\)'
            if !has_key(s:initial_files, l:to_append)
                if filereadable(g:_zsh_hist_fname)
                    let l:hist = readfile(g:_zsh_hist_fname)
                else
                    let l:hist = []
                endif
                call add(l:hist, l:to_append)
                call writefile(l:hist, g:_zsh_hist_fname)
            endif
        endif
    endfunction
    function! s:reorder_zsh_hist ()
        let l:current_file = expand("%:~:.")
        if filereadable(g:_zsh_hist_fname)
            let l:hist = readfile(g:_zsh_hist_fname)
            if !has_key(s:initial_files, l:current_file)
                call filter(l:hist, 'v:val != l:current_file')
            endif
            call add(l:hist, l:current_file)
            call writefile(l:hist, g:_zsh_hist_fname)
        endif
    endfunction
endif
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
    " why does this not happen automatically?
    normal! zM
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
        normal! zv
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
" }}}
" nopaste {{{
function! s:nopaste(visual)
    if a:visual
        silent normal! gv:!nopaste<CR>
    else
        let l:pos = getpos('.')
        silent normal! :%!nopaste<CR>
    endif
    silent normal! "+yy
    let @* = @+
    silent undo
    " can't restore visual selection because that will overwrite "*
    if !a:visual
        call setpos('.', l:pos)
    endif
    echo @+
endfunction
nnoremap <silent><Leader>p :call <SID>nopaste(0)<CR>
xnoremap <silent><Leader>p :<C-U>call <SID>nopaste(1)<CR>
" }}}
" better version of keywordprg {{{
function! Help(visual, iskeyword, command)
    let l:iskeyword = &iskeyword
    for l:kw in a:iskeyword
        exe 'set iskeyword+=' . l:kw
    endfor
    if a:visual
        let l:oldreg = @a
        normal! gv"aygv
        let l:word = @a
        let @a = l:oldreg
    else
        let l:word = expand('<cword>')
    endif
    let &iskeyword = l:iskeyword

    exe 'noswapfile ' . &helpheight . 'new ' . l:word
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal nobuflisted

    setlocal modifiable
    exe 'call ' . a:command . '("' . l:word . '")'
    normal! ggdd
    setlocal nomodifiable
endfunction
function! s:man(word)
    exe 'silent read! man -Pcat ' . a:word
    setlocal filetype=man
endfunction
nnoremap <silent>K :call Help(0, [], '<SID>man')<CR>
xnoremap <silent>K :call Help(1, [], '<SID>man')<CR>
" }}}
" auto-append closing characters {{{
function s:move_cursor_left()
    return "\<Esc>i"
endfunction
function s:prevchar()
    return getline('.')[col('.') - 2]
endfunction
function s:nextchar()
    return getline('.')[col('.') - 1]
endfunction
let g:pair_cr_maps = {
\    '(': "<SID>go_up()",
\    '[': "<SID>go_up()",
\    '{': "<SID>go_up()",
\}
function s:maybe_reposition_cursor()
    return eval(g:pair_cr_maps[s:prevchar()])
endfunction
function s:go_up()
    return "\<CR>\<Esc>O"
endfunction
let g:pair_bs_maps = {
\    '"': "<SID>maybe_remove_adjacent_char('\"')",
\    "'": "<SID>maybe_remove_adjacent_char(\"'\")",
\    '(': "<SID>maybe_remove_empty_pair(')')",
\    '[': "<SID>maybe_remove_empty_pair(']')",
\    '{': "<SID>maybe_remove_empty_pair('}')",
\    '': "<SID>maybe_collapse_pair()",
\}
function s:maybe_remove_matching_pair()
    return eval(g:pair_bs_maps[s:prevchar()])
endfunction
function s:maybe_remove_adjacent_char(char)
    if s:nextchar() == a:char
        return "\<BS>\<Del>"
    else
        return "\<BS>"
    endif
endfunction
function s:maybe_remove_empty_pair(char)
    let l:start = [line('.'), col('.')]
    let l:end = searchpos('[^ \t]', 'cnWz')
    if l:end == [0, 0]
        return "\<BS>"
    endif

    let l:next_nonblank = getline(l:end[0])[l:end[1] - 1]
    if l:next_nonblank != a:char
        return "\<BS>"
    endif

    let l:diff = [l:end[0] - l:start[0], l:end[1] - l:start[1]]
    if l:diff[0] == 0
        return "\<BS>" . repeat("\<Del>", l:diff[1] + 1)
    elseif l:diff[0] == 1
        return "\<Esc>" . (l:diff[0] + 1) . "Ji" . "\<BS>\<Del>\<Del>"
    else
        return "\<Esc>" . (l:diff[0] + 1) . "Ji" . "\<BS>\<BS>\<Del>"
    endif
endfunction
let g:pair_chars = {
\    '(': ')',
\    '[': ']',
\    '{': '}',
\}
function s:maybe_collapse_pair()
    let l:prev_line_idx = line('.') - 1
    if l:prev_line_idx < 1
        return "\<BS>"
    endif

    let l:prev_line_char = getline(l:prev_line_idx)[col([l:prev_line_idx, '$'])-2]
    if l:prev_line_char !~ '[([{]'
        return "\<BS>"
    endif

    let l:end = searchpos('[^ \t]', 'cnWz')
    if l:end == [0, 0]
        return "\<BS>"
    endif

    let l:next_nonblank = getline(l:end[0])[l:end[1] - 1]
    if l:next_nonblank != g:pair_chars[l:prev_line_char]
        return "\<BS>"
    endif

    return "\<Esc>\<BS>JJi\<BS>"
endfunction
function s:skip_closing_char(char)
    if s:nextchar() == a:char
        return "\<Esc>la"
    else
        return a:char
    endif
endfunction
for [s:start, s:end] in [['(', ')'], ['{', '}'], ['[', ']']]
    exe "inoremap <silent> ".s:start." ".s:start.s:end."<C-R>=<SID>move_cursor_left()<CR>"
    exe "inoremap <silent> ".s:end." <C-R>=<SID>skip_closing_char('".s:end."')<CR>"
endfor
inoremap <silent><expr> ' <SID>nextchar() == "'" ? "\<C-R>=\<SID>skip_closing_char(\"'\")\<CR>" : col('.') == 1 \|\| match(<SID>prevchar(), '\W') != -1 ? "''\<C-R>=\<SID>move_cursor_left()\<CR>" : "'"
inoremap <silent><expr> " <SID>nextchar() == '"' ? "\<C-R>=\<SID>skip_closing_char('\"')\<CR>" : "\"\"\<C-R>=\<SID>move_cursor_left()\<CR>"
inoremap <silent><expr> <BS> has_key(g:pair_bs_maps, <SID>prevchar()) ? "\<C-R>=\<SID>maybe_remove_matching_pair()\<CR>" : "\<BS>"
inoremap <silent><expr> <CR> has_key(g:pair_cr_maps, <SID>prevchar()) ? "\<C-R>=\<SID>maybe_reposition_cursor()\<CR>" : "\<CR>"
" }}}
" Prompt to create directories if they don't exist {{{
autocmd vimrc BufNewFile * :call <SID>ensure_dir_exists()
function! s:ensure_dir_exists ()
    let l:required_dir = expand("%:h")
    if !isdirectory(l:required_dir)
        if <SID>ask_quit("Directory '" . l:required_dir . "' doesn't exist.", "&Create it?")
            return
        endif

        try
            call mkdir( l:required_dir, 'p' )
        catch
            call <SID>ask_quit("Can't create '" . l:required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction
function! s:ask_quit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        if len(getbufinfo()) > 1
            silent bd
            return 1
        else
            exit
        end
    endif
    return 0
endfunction
" }}}
" }}}
" vim: fdm=marker
