""" GENERAL """
set nocompatible
syntax on
filetype indent plugin on
augroup opinionated_defaults
    autocmd!
augroup END


""" PERSISTENCE """

" remember as many history items as possible (command, search, etc)
set history=10000
" enable persistent undo (undo even after closing and reopening vim)
if has('persistent_undo')
    let s:undocachedir = $HOME . '/.cache/vim/undo'
    if !isdirectory(s:undocachedir)
        call mkdir(s:undocachedir, 'p')
    endif
    exe "set undodir=" . s:undocachedir
    set undofile
endif
" use a separate swapfile directory
let s:swapfiledir = $HOME . '/.cache/vim/swap'
if !isdirectory(s:swapfiledir)
    call mkdir(s:swapfiledir, 'p')
endif
exe "set directory=" . s:swapfiledir
" use a separate view directory
let s:viewdir = $HOME . '/.cache/vim/view'
if !isdirectory(s:viewdir)
    call mkdir(s:viewdir, 'p')
endif
exe "set viewdir=" . s:viewdir


""" BUFFERS """

" automatically write the buffer before :make, shell commands, etc
set autowrite
" ask to save modified buffers when quitting, instead of throwing an error
set confirm
" allow switching to other buffers when the current one is modified
set hidden
" these two restore the last known cursor position when a buffer is loaded
set nostartofline
autocmd opinionated_defaults BufReadPost *
    \ if line("'\"") <= line('$') |
        \ exe 'normal! g`"' |
    \ endif


""" DISPLAY """

" show as much of a line as possible if it doesn't all fit on the screen
set display+=truncate
" more useful display of nonprinting characters (<07> instead of ^G)
set display+=uhex
" don't redraw in the middle of noninteractive commands (maps, macros, etc)
set lazyredraw
" always give a message for the number of lines delete/changed
set report=0
" keep some additional context visible when scrolling
set scrolloff=5
if has('cmdline_info')
    " display the current partial command and size of the visual selection
    set showcmd
endif
if has('conceal')
    " enable syntax-specific hiding of text
    set conceallevel=2
endif
if has('linebreak')
    " display a marker when a line was wrapped
    set showbreak=>
endif


""" EDITING """

" automatically use an indent that matches the previous line
set autoindent
" allow backspacing over everything
set backspace=indent,eol,start
" remove leading comment characters intelligently when joining lines
set formatoptions+=j
" always join with a single space, even between sentences
set nojoinspaces
" try to always keep indentation lined up on shiftwidth boundaries
set shiftround
" keep softtabstop and shiftwidth in sync
set softtabstop=-1


""" COMMAND MODE """

" make command mode completion work more like the shell:
"   first, complete the longest common sequence,
"   then show a list,
"   then cycle through completing the full names in the list in order
set wildmode=longest,list,full
if exists('+wildignorecase')
    " make command mode completion case insensitive
    set wildignorecase
endif


""" SEARCH """

" make searches case-insensitive
set ignorecase
" unless they include a capital letter
set smartcase
if has('extra_search')
    " highlight all matches when searching
    set hlsearch
endif


""" TERMINAL STUFF """

" wait a much shorter amount of time for escape sequences
" (this makes <Esc> much more responsive)
set ttimeoutlen=50
" send text to the terminal in such a way that line wrapping is done at the
" terminal level, so copying and pasting wrapped lines works correctly
" (assuming you temporarily unset showbreak)
set ttyfast
" entirely disable error bells:
" make all bells visual bells
set visualbell
" and then disable visual bells
set t_vb=


""" COLORS """

" force vim to use 256 colors
" (it typically can't detect this while in screen/tmux since TERM=screen
" doesn't advertise it, even though ~everything does support it these days)
set t_Co=256
" globally highlight diff conflict markers
match ErrorMsg '^\(<\||\|=\|>\)\{7\}\([^=].\+\)\?$'


""" MAPPINGS """

" keep the current selection when indenting
xnoremap < <gv
xnoremap > >gv
" make Y behave analogously to D instead of dd
nnoremap Y y$
" make arrow keys move visually (since j/k already move linewise)
noremap  <up>   gk
noremap  <down> gj
inoremap <up>   <C-o>gk
inoremap <down> <C-o>gj
