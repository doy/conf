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
autocmd vimrc CmdWinEnter * nnoremap <buffer><CR> <CR>
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
autocmd vimrc BufWinEnter,FileType * runtime plugin/rainbow_paren.vim
" }}}
" }}}
" vim: fdm=marker
