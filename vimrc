" options {{{
set shiftwidth=4
set expandtab
" }}}
" hooks {{{
augroup vimrc
    autocmd!
augroup END
" }}}
" bindings {{{
" general {{{
let g:mapleader = ';'
let g:maplocalleader = ';'
" }}}
" M to :make {{{
noremap  <silent>M :<C-u>make<CR><CR><C-W>k
" }}}
" F11 for spell checking {{{
noremap  <silent><expr><F11> &spell ? ":\<C-u>setlocal nospell\<CR>" : ":\<C-u>setlocal spell\<CR>"
inoremap <silent><expr><F11> &spell ? "\<C-o>:setlocal nospell\<CR>" : "\<C-o>:setlocal spell\<CR>"
" }}}
" editing binary files {{{
nnoremap <C-B> :%!xxd<CR>
nnoremap <C-R> :%!xxd -r<CR>
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
" use tab for completion {{{
inoremap <expr> <Tab>
    \ strpart(getline('.'), 0, col('.') - 1) =~ '\(^\\|\s\+\)$'
        \ ? "\<Tab>"
        \ : "\<C-n>"
inoremap <S-Tab> <C-p>
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
" fzf {{{
let g:fzf_layout = { 'up': '~40%' }
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 "--hidden",
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%', '?'),
  \                 <bang>0)
nnoremap <silent> t :Files<CR>
nnoremap <silent> ff :Ag<CR>
nnoremap <silent> fh :Helptags<CR>
nnoremap <silent> ft :Filetypes<CR>
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
" matchit {{{
packadd! matchit
" }}}
" multiple-cursors
" neosnippet {{{
let g:neosnippet#snippets_directory = '~/.vim/snippets'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

function! s:configure_neosnippet_tab_mappings()
    let g:neosnippet_tab_override_i_tab = maparg("<Tab>", "i", 0, 1)
    let g:neosnippet_tab_override_i_stab = maparg("<S-Tab>", "i", 0, 1)
    let g:neosnippet_tab_override_s_tab = maparg("<Tab>", "s", 0, 1)
    imap <expr> <Tab>
        \ neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ g:neosnippet_tab_override_i_tab["expr"]
                \ ? eval(g:neosnippet_tab_override_i_tab["rhs"])
                \ : g:neosnippet_tab_override_i_tab["rhs"]
    imap <expr> <S-Tab>
        \ neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ g:neosnippet_tab_override_i_stab["expr"]
                \ ? eval(g:neosnippet_tab_override_i_stab["rhs"])
                \ : g:neosnippet_tab_override_i_stab["rhs"]
    smap <expr> <Tab>
        \ neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ g:neosnippet_tab_override_s_tab["expr"]
                \ ? eval(g:neosnippet_tab_override_s_tab["rhs"])
                \ : g:neosnippet_tab_override_s_tab["rhs"]
endfunction
autocmd vimrc VimEnter * call <SID>configure_neosnippet_tab_mappings()
" }}}
" rainbow {{{
let g:rainbow = 1
let g:rainbow_paren = 1
let g:rainbow_bracket = 1
let g:rainbow_brace = 1
" }}}
" startify {{{
let g:startify_list_order = ['dir', 'bookmarks', 'commands']
let g:startify_files_number = 7
let g:startify_commands = [
    \ {'t': ['Open file', 'Files']},
    \ {'ff': ['Grep', 'Ag']},
    \ {'fh': ['Help', 'Helptags']},
    \ ]
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = [
    \'!', '@', '#', '$', '%', '^', '&', '*', '(', ')'
\]
let g:startify_custom_header = []
let s:fortune = system('fortune -n200 -s ~/.fortune | grep -v -E "^$"')
let g:startify_custom_footer = [''] + map(split(s:fortune, '\n'), '"   ".v:val')
" }}}
" textobj {{{
let g:Textobj_defs = [
   \['/', 'Textobj_paired', '/'],
   \['\|', 'Textobj_paired', '\|'],
\]
" }}}
" }}}
" vim: fdm=marker
