" based on Eidolos's .vimrc, at http://sartak.org/conf/vimrc
" General options {{{
" Miscellaneous {{{
" fuck vi! long live vim!
set nocompatible

" indentation FTW.. also plugins FTW! heh
filetype indent plugin on

" automatically flush to disk when using :make, etc.
set autowrite

" Gentoo disables modelines by default
set modeline
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

" tab completion stuff for the command line
set wildmode=longest,list,full

" word wrapping
set linebreak

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
"}}}
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
"}}}
" Make vim less whiny {{{
" :bn with a change in the current buffer? no prob!
set hidden

" no bells whatsoever
set vb t_vb=

" if you :q with changes it asks you if you want to continue or not
set confirm

" 50 milliseconds for escape timeout instead of 1000
set ttimeoutlen=50
"}}}
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

" figure out indent when ; is pressed
set cinkeys+=;

" align break with case in a switch
set cinoptions+=b1
"}}}
" Folding {{{
" fold only when I ask for it damnit!
set foldmethod=marker

" use my custom fold display function
set foldtext=Base_foldtext()

" foldtext overrides {{{
" Base {{{
function Base_foldtext(...)
    " use the argument for display if possible, otherwise the current line {{{
    if a:0 > 0
        let line = a:1
    else
        let line = getline(v:foldstart)
    endif
    " }}}
    " remove the marker that caused this fold from the display {{{
    let foldmarkers = split(&foldmarker, ',')
    let line = substitute(line, '\V' . foldmarkers[0], ' ', '')
    " }}}
    " remove comments that vim knows about {{{
    let comment = split(&commentstring, '%s')
    if comment[0] != ''
        let comment_begin = comment[0]
        let comment_end = ''
        if len(comment) > 1
            let comment_end = comment[1]
        end
        let pattern = '\V' . comment_begin . '\s\*' . comment_end . '\s\*\$'
        if line =~ pattern
            let line = substitute(line, pattern, ' ', '')
        else
            let line = substitute(line, '.*\V' . comment_begin, ' ', '')
            if comment_end != ''
                let line = substitute(line, '\V' . comment_end, ' ', '')
            endif
        endif
    endif
    " }}}
    " remove any remaining leading or trailing whitespace {{{
    let line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
    " }}}
    " align everything, and pad the end of the display with - {{{
    let line = printf('%-' . (62 - v:foldlevel) . 's', line)
    let line = strpart(line, 0, 62 - v:foldlevel)
    let line = substitute(line, '\%( \)\@<= \%( *$\)\@=', '-', 'g')
    " }}}
    " format the line count {{{
    let cnt = printf('%13s', '(' . (v:foldend - v:foldstart + 1) . ' lines) ')
    " }}}
    return '+-' . v:folddashes . ' ' . line . cnt
endfunction
" }}}
" Latex {{{
let s:latex_types = {'thm': 'Theorem', 'cor':  'Corollary',
                   \ 'lem': 'Lemma',   'defn': 'Definition'}
function s:lower_letter(i) " {{{
    return tolower(s:upper_letter(a:i))
endfunction " }}}
function s:roman_numeral(i) " {{{
    let numeral = ''
    let chars = 'ivxlcdm'
    let i = a:i
    for base in [0, 2, 4]
        let c1 = strpart(chars, base, 1)
        let c5 = strpart(chars, base + 1, 1)
        let c10 = strpart(chars, base + 2, 1)
        let digit = i % 10
        if digit == 1
            let numeral = c1 . numeral
        elseif digit == 2
            let numeral = c1 . c1 . numeral
        elseif digit == 3
            let numeral = c1 . c1 . c1 . numeral
        elseif digit == 4
            let numeral = c1 . c5 . numeral
        elseif digit == 5
            let numeral = c5 . numeral
        elseif digit == 6
            let numeral = c5 . c1 . numeral
        elseif digit == 7
            let numeral = c5 . c1 . c1 . numeral
        elseif digit == 8
            let numeral = c5 . c1 . c1 . c1 . numeral
        elseif digit == 9
            let numeral = c1 . c10 . numeral
        endif
        let i = i / 10
        if i == 0
            break
        end
    endfor

    return repeat('m', i) . numeral
endfunction " }}}
function s:upper_letter(i) " {{{
    if a:i <= 26
        return nr2char(char2nr('A') + a:i - 1)
    else
        return 'ERROR'
    endif
endfunction " }}}
function s:enumeration(depth, index) " {{{
    if a:depth == 0
        return a:index + 1
    elseif a:depth == 1
        return '(' . s:lower_letter(a:index + 1) . ')'
    elseif a:depth == 2
        return s:roman_numeral(a:index + 1)
    elseif a:depth == 3
        return s:upper_letter(a:index + 1)
    else
        return 'Error: invalid depth'
    endif
endfunction " }}}
function Latex_foldtext() " {{{
    let line = getline(v:foldstart)
    " format theorems/etc nicely {{{
    let matches = matchlist(line, '\\begin{\([^}]*\)}')
    if !empty(matches) && has_key(s:latex_types, matches[1])
        let type = s:latex_types[matches[1]]
        let label = ''
        let linenum = v:foldstart - 1
        while linenum <= v:foldend
            let linenum += 1
            let line = getline(linenum)
            let matches = matchlist(line, '\\label{\([^}]*\)}')
            if !empty(matches)
                let label = matches[1]
                break
            endif
        endwhile
        if label != ''
            let label = ": " . label
        endif
        return Base_foldtext(type . label)
    endif
    " }}}
    " format list items nicely {{{
    " XXX: nesting different types of lists doesn't give quite the correct
    " result - an enumerate inside an itemize inside an enumerate should use
    " (a), but here it will go back to using 1.
    if line =~ '\\item'
        let item_name = []
        let item_depth = 0
        let nesting = 0
        let type = ''
        for linenum in range(v:foldstart, 0, -1)
            let line = getline(linenum)
            if line =~ '\\item'
                if nesting == 0
                    let label = matchstr(line, '\\item\[\zs[^]]*\ze\]')
                    if len(item_name) == item_depth
                        if label != ''
                            let item_name += [label]
                        else
                            let item_name += [0]
                        endif
                    else
                        if type(item_name[item_depth]) == type(0) && label == ''
                            let item_name[item_depth] += 1
                        endif
                    endif
                endif
            elseif line =~ '\\begin{document}'
                break
            elseif line =~ '\\begin'
                if nesting > 0
                    let nesting -= 1
                else
                    let new_type = matchstr(line, '\\begin{\zs[^}]*\ze}')
                    if type == ''
                        let type = new_type
                    elseif type != new_type
                        let item_name = item_name[0:-2]
                        break
                    endif
                    let item_depth += 1
                endif
            elseif line =~ '\\end'
                let nesting += 1
            endif
        endfor
        " XXX: vim crashes if i just reverse the actual list
        " should be fixed in patch 7.1.287
        "let item_name = reverse(item_name)
        let item_name = reverse(deepcopy(item_name))
        for i in range(len(item_name))
            if type(item_name[i]) != type('')
                let item_name[i] = s:enumeration(i, item_name[i])
            endif
        endfor
        let type = toupper(strpart(type, 0, 1)) . strpart(type, 1)
        let line = type . ': ' . join(item_name, '.')
        return Base_foldtext(line)
    endif
    " }}}
    return Base_foldtext(line)
endfunction " }}}
" }}}
" C++ {{{
function Cpp_foldtext()
    let line = getline(v:foldstart)
    " strip out // comments {{{
    let block_open = stridx(line, '/*')
    let line_open = stridx(line, '//')
    if block_open == -1 || line_open < block_open
        return Base_foldtext(substitute(line, '//', ' ', ''))
    endif
    " }}}
    return Base_foldtext(line)
endfunction
" }}}
" Perl {{{
function Perl_foldtext()
    let line = getline(v:foldstart)
    " format sub names with their arguments {{{
    let matches = matchlist(line,
    \   '^\s*\(sub\|around\|before\|after\|guard\)\s*\(\w\+\)')
    if !empty(matches)
        let linenum = v:foldstart - 1
        let sub_type = matches[1]
        let params = []
        while linenum <= v:foldend
            let linenum += 1
            let next_line = getline(linenum)
            " skip the opening brace and comment lines and blank lines
            if next_line =~ '\s*{\s*' || next_line =~ '^\s*#' || next_line == ''
                continue
            endif

            " handle 'my $var = shift;' type lines
            let var = '\%(\$\|@\|%\|\*\)\w\+'
            let shift_line = matchlist(next_line,
            \   'my\s*\(' . var . '\)\s*=\s*shift\%(\s*||\s*\(.\{-}\)\)\?;')
            if !empty(shift_line)
                if shift_line[1] == '$self' && empty(params)
                    if sub_type == 'sub'
                        let sub_type = ''
                    endif
                    let sub_type .= ' method'
                elseif shift_line[1] == '$class' && empty(params)
                    if sub_type == 'sub'
                        let sub_type = ''
                    endif
                    let sub_type .= ' static method'
                elseif shift_line[1] != '$orig'
                    let arg = shift_line[1]
                    " also catch default arguments
                    if shift_line[2] != ''
                        let arg .= ' = ' . shift_line[2]
                    endif
                    let params += [l:arg]
                endif
                continue
            endif

            " handle 'my ($a, $b) = @_;' type lines
            let rest_line = matchlist(next_line, 'my\s*(\(.*\))\s*=\s*@_;')
            if !empty(rest_line)
                let rest_params = split(rest_line[1], ',\s*')
                let params += rest_params
                continue
            endif

            " handle 'my @args = @_;' type lines
            let array_line = matchlist(next_line, 'my\s*\(@\w\+\)\s*=\s*@_;')
            if !empty(array_line)
                let params += [array_line[1]]
                continue
            endif

            " handle 'my %args = @_;' type lines
            let hash_line = matchlist(next_line, 'my\s*%\w\+\s*=\s*@_;')
            if !empty(hash_line)
                let params += ['paramhash']
                continue
            endif

            " handle unknown uses of shift
            if next_line =~ '\%(\<shift\>\%(\s*@\)\@!\)'
                let params += ['$unknown']
                continue
            endif

            " handle unknown uses of @_
            if next_line =~ '@_\>'
                let params += ['@unknown']
                continue
            endif
        endwhile

        let params = filter(params[0:-2], 'strpart(v:val, 0, 1) != "@"') +
        \            [params[-1]]

        return Base_foldtext(sub_type . ' ' . matches[2] .
        \                    '(' . join(params, ', ') . ')')
    endif
    " }}}
    return Base_foldtext(line)
endfunction
" }}}
" }}}
"}}}
"}}}
" Colors {{{
colorscheme peachpuff
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
highlight Search NONE ctermfg=red
"}}}
" color end of line whitespace {{{
autocmd BufWinEnter * syn match EOLWS excludenl /\s\+$/
hi EOLWS ctermbg=red
" }}}
"}}}
" Autocommands {{{
" When editing a file, always jump to the last cursor position {{{
autocmd BufReadPost *
\  if line("'\"") > 0 && line("'\"") <= line("$") |
\    exe "normal g`\"" |
\  endif
"}}}
" Skeletons {{{
autocmd BufNewFile *.pl     silent 0read ~/.vim/skeletons/perl.pl  | normal Gdd
autocmd BufNewFile *.pm     silent 0read ~/.vim/skeletons/perl.pm  | exe 'normal 4G' | silent :.s/Foo/\=expand("%")/ | silent :.s#lib/## | silent :.s#/#::#g | silent :.s/.pm;/;/ | normal Gdd2k
autocmd BufNewFile *.cpp    silent 0read ~/.vim/skeletons/cpp.cpp  | normal Gddk
autocmd BufNewFile *.c      silent 0read ~/.vim/skeletons/c.c      | normal Gddk
autocmd BufNewFile *.tex    silent 0read ~/.vim/skeletons/tex.tex  | normal Gddk
autocmd BufNewFile Makefile silent 0read ~/.vim/skeletons/Makefile | normal Gddgg$
" }}}
" Auto +x {{{
au BufWritePost *.{sh,pl} silent exe "!chmod +x %"
"}}}
" Perl :make does a syntax check {{{
autocmd FileType perl setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType perl setlocal errorformat=%f:%l:%m
autocmd FileType perl setlocal keywordprg=perldoc\ -f
"}}}
" Latex :make converts to pdf {{{
autocmd FileType tex setlocal makeprg=~/bin/latexpdf\ --show\ %
" }}}
" Lua needs to have commentstring set {{{
autocmd FileType lua setlocal commentstring=--%s
" }}}
" Set up custom folding {{{
autocmd FileType tex  setlocal foldtext=Latex_foldtext()
autocmd FileType cpp  setlocal foldtext=Cpp_foldtext()
autocmd FileType perl setlocal foldtext=Perl_foldtext()
" }}}
"}}}
" Insert-mode remappings/abbreviations {{{
" Arrow keys, etc {{{
imap <up> <C-o>gk
imap <down> <C-o>gj
imap <home> <C-o>g<home>
imap <end> <C-o>g<end>
" }}}
" Hit <C-a> in insert mode after a bad paste (thanks absolon) {{{
inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi
"}}}
" }}}
" Normal-mode remappings {{{
" have Y behave analogously to D rather than to dd
nmap Y y$

nnoremap \\ \
nmap <silent>\/ :nohl<CR>
nmap <silent>\s :syntax sync fromstart<CR>
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
imap <F11> <C-o>:call <SID>spell()<CR>
"}}}
" Arrow keys, etc, again {{{
map <up> gk
map <down> gj
map <home> g<home>
map <end> g<end>
" }}}
"}}}
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
" }}}
" Text objects {{{
" Text object creation {{{
let g:text_object_number = 0
function Textobj(char, callback)
    let g:text_object_number += 1
    function Textobj_{g:text_object_number}(inner, operator, count, callback)
        try
            let pos = getpos('.')
            sandbox let [startline, startcol, endline, endcol] = function(a:callback)(a:inner, a:count)
        catch /no-match/
            return
        finally
            call setpos('.', pos)
        endtry
        if startline == endline
            let objlength = endcol - startcol + 1
        else
            let lines = getline(startline + 1, endline - 1)
            let lines = [strpart(getline(startline), startcol - 1)] +
            \           lines +
            \           [strpart(getline(endline), 0, endcol)]
            let objlength = 0
            for line in lines
                let objlength += strlen(line) + 1
            endfor
            let objlength -= 1
        endif
        if startcol > strlen(getline(startline))
            let startcol = 1
            let startline += 1
            let objlength -= 1
        endif
        call cursor(startline, startcol)
        exe 'normal! '.a:operator.objlength.' '

        if a:operator == 'c'
            normal! l
            startinsert
        elseif a:operator == 'v'
            exe "normal! \<BS>"
        endif
    endfunction

    exe 'onoremap <silent>a'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(0, v:operator, v:prevcount, "'.a:callback.'")<CR>'
    exe 'onoremap <silent>i'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(1, v:operator, v:prevcount, "'.a:callback.'")<CR>'
    exe 'xnoremap <silent>a'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(0, "v", v:prevcount, "'.a:callback.'")<CR>'
    exe 'xnoremap <silent>i'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(1, "v", v:prevcount, "'.a:callback.'")<CR>'
endfunction
" }}}
" Text objects {{{
" / for regex {{{
function Textobj_regex(inner, count)
    let pos = getpos('.')

    let line = strpart(getline(pos[1]), 0, pos[2])
    let lines = getline(1, pos[1] - 1) + [line]
    let linenum = pos[1]
    for line in reverse(lines)
        let objstart = match(line, '.*\zs\\\@<!/') + 1
        if objstart != 0
            break
        endif
        let linenum -= 1
    endfor
    if objstart == 0
        throw 'no-match'
    endif
    let objstart += a:inner
    let objstartline = linenum

    let line = strpart(getline(pos[1]), pos[2] - 1)
    let lines = [line] + getline(pos[1] + 1, line('$'))
    let linenum = pos[1]
    for line in lines
        let objend = match(line, '\\\@<!/') + 1
        if objend != 0
            if linenum == pos[1]
                " have to account for the possibility of a split escape
                " sequence
                if objend == 1
                    if getline(pos[1])[pos[2] - 2] == '\'
                        let objend = match(line, '\\\@<!/', 1) + 1
                        if objend == 0
                            let linenum += 1
                            continue
                        endif
                    else
                        " if we're sitting on a /, don't do anything, since it's
                        " impossible to know which direction to look
                        throw 'no-match'
                    endif
                endif
                let objend += pos[2] - 1
            endif
            break
        endif
        let linenum += 1
    endfor
    if objend == 0
        throw 'no-match'
    endif
    let objend -= a:inner
    let objendline = linenum

    return [objstartline, objstart, objendline, objend]
endfunction
call Textobj('/', 'Textobj_regex')
" }}}
" f for folds {{{
function Textobj_fold(inner, count)
    if foldlevel(line('.')) == 0
        throw 'no-match'
    endif
    exe 'normal! '.a:count.'[z'
    let startline = line('.') + a:inner
    normal! ]z
    let endline = line('.') - a:inner

    return [startline, 1, endline, strlen(getline(endline))]
endfunction
call Textobj('f', 'Textobj_fold')
" }}}
" , for function arguments {{{
function Textobj_arg(inner, count)
    let pos = getpos('.')
    let curchar = getline(pos[1])[pos[2] - 1]
    if curchar == ','
        if getline(pos[1])[pos[2] - 2] =~ '\s'
            normal! gE
        else
            exe "normal! \<BS>"
        endif
        return Textobj_arg(a:inner, a:count)
    elseif curchar =~ '\s'
        normal! W
        return Textobj_arg(a:inner, a:count)
    endif

    let line = strpart(getline(pos[1]), 0, pos[2])
    let lines = getline(1, pos[1] - 1) + [line]
    let linenum = pos[1]
    for line in reverse(lines)
        let argbegin = matchend(line, '.*\%(,\s*\|(\)') + 1
        if argbegin != 0
            while argbegin > strlen(line)
                let linenum += 1
                let line = getline(linenum)
                let argbegin = matchend(line, '^\s*') + 1
            endwhile
            break
        endif
        let linenum -= 1
    endfor
    if argbegin == 0
        throw 'no-match'
    endif
    let argstartline = linenum

    let line = strpart(getline(pos[1]), pos[2] - 1)
    let lines = [line] + getline(pos[1] + 1, line('$'))
    let linenum = pos[1]
    for line in lines
        let argend = match(line, '\zs.\?\%(,\|)\)') + 1
        if argend != 0
            if linenum == pos[1]
                let argend += pos[2] - 1
            endif
            if argend == 1 && getline(linenum)[argend - 1] == ')'
                let linenum -= 1
                let argend = strlen(getline(linenum))
            endif
            break
        endif
        let linenum += 1
    endfor
    if argend == 0
        throw 'no-match'
    endif
    let argendline = linenum

    if a:inner == 0
        let endline = getline(argendline)
        let startline = getline(argstartline)
        if argend >= strlen(endline)
            let argend = 0
            let argendline += 1
            let endline = getline(argendline)
        endif
        if endline[argend] == ')' && startline[argbegin - 2] != '('
            let argbegin = match(strpart(startline, 0, argbegin - 1), '\s*$')
            while argbegin == 0
                let argstartline -= 1
                let startline = getline(argstartline)
                let argbegin = strlen(startline)
            endwhile
        elseif endline[argend] != ')'
            let argend += matchend(strpart(endline, argend + 1), '^\s*') + 1
            if startline[argbegin - 2] == '('
                for line in [strpart(endline, argend)] +
                \           getline(argendline + 1, line('$'))
                    let argincr = matchend(line, '\s*\ze\S')
                    if argincr != -1
                        let argend += argincr
                        break
                    endif
                    let argendline += 1
                    let argend = 0
                endfor
            endif
        endif
        if argend >= strlen(endline)
            if argendline == argstartline
                let newbegin = matchend(strpart(endline, 0, argbegin), '.*,')
                if newbegin != -1
                    let argbegin = newbegin + 1
                endif
            endif
            let argend = 0
            let argendline += 1
        endif
    endif

    return [argstartline, argbegin, argendline, argend]
endfunction
call Textobj(',', 'Textobj_arg')
" }}}
" }}}
" }}}
