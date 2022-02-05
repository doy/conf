" options {{{
set shiftwidth=4
set expandtab
set termguicolors
let &t_8f="\e[38;2;%lu;%lu;%lum"
let &t_8b="\e[48;2;%lu;%lu;%lum"
colorscheme local
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
" S for spell checking {{{
noremap  <silent><expr>S &spell ? ":\<C-u>setlocal nospell\<CR>" : ":\<C-u>setlocal spell\<CR>"
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
" ale
" airline
" autobrace
" commentary {{{
map <silent><Leader>x :Commentary<CR>
" }}}
" diff-changes {{{
nnoremap <silent>ds :DiffAgainstFilesystem<CR>
nnoremap <silent>dc :DiffAgainstVCS<CR>
nnoremap <silent>de :DiffStop<CR>
" }}}
" fzf {{{
let g:fzf_layout = { 'up': '~40%' }
if &columns >= 160
    let s:horiz_preview_layout = 'right:50%'
else
    let s:horiz_preview_layout = 'right:50%:hidden'
endif
let s:ag_opts = {"options": ["-d:", "-n4.."]}
function! s:fzf_files()
    silent let out = system("git rev-parse --show-toplevel 2>/dev/null")
    if strlen(out)
        exe "GFiles -co --exclude-standard"
    else
        exe "Files"
    endif
endfunction
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case --no-ignore-messages '.shellescape(<q-args>),
  \                 1,
  \                 <bang>0 ? fzf#vim#with_preview(s:ag_opts, 'up:60%')
  \                         : fzf#vim#with_preview(s:ag_opts, s:horiz_preview_layout, '?'),
  \                 <bang>0)
nnoremap <silent> t :call <SID>fzf_files()<CR>
nnoremap <silent> ff :Rg<CR>
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
" history-sync
" matchit {{{
packadd! matchit
" }}}
" netrw {{{
let g:netrw_home = $HOME . '/.cache/vim/netrw'
if !isdirectory(g:netrw_home)
    call mkdir(g:netrw_home, 'p')
endif
" }}}
" polyglot {{{
" this is for things that can't be set in ftplugin files for whatever reason
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:polyglot_disabled = ['csv', 'sensible', 'autoindent', 'pascal']
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
    \ {'ff': ['Grep', 'Rg']},
    \ {'fh': ['Help', 'Helptags']},
    \ ]
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = [
    \'!', '@', '#', '$', '%', '^', '&', '*', '(', ')'
\]
let g:startify_custom_header = []
let s:fortune = system('fortune -n200 -s ~/.local/share/fortune | grep -v -E "^\$"')
let g:startify_custom_footer = [''] + map(split(s:fortune, '\n'), '"   ".v:val')
" }}}
" textobj {{{
let g:textobj_defs = {
\    '/': ['paired'],
\    '\|': ['paired'],
\}
" }}}
" }}}
" vim: fdm=marker
