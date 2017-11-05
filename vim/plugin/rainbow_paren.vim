" this script by Shawn M Moore aka Sartak <sartak at gmail.com>
" also by Michael R Geddes aka frogonwheels <vimmer at frog.wheelycreek.net>
" originally by anonymous

" this in the public domain
" last updated 25 Mar 07

" this does nothing unless you,
"   let g:rainbow = 1

" and set which kinds of character pairs you want to rainbow
"   let g:rainbow_paren   = 1 " ()
"   let g:rainbow_brace   = 1 " {}
"   let g:rainbow_bracket = 1 " []
"   let g:rainbow_angle   = 1 " <>

" if you want the different types to nest, such that the braces in ({}) are
" colored the same as the internal parens of (()), then
"   let g:rainbow_nested = 1

function! Rainbow()
  let s:basename = 'level'
  exe 'hi '.s:basename.'1c ctermfg=darkcyan    guifg=cyan'
  exe 'hi '.s:basename.'2c ctermfg=darkgreen   guifg=green'
  exe 'hi '.s:basename.'3c ctermfg=darkyellow  guifg=yellow'
  exe 'hi '.s:basename.'4c ctermfg=darkblue    guifg=blue'
  exe 'hi '.s:basename.'5c ctermfg=darkmagenta guifg=magenta'
  " this color is never nested, it only appears on the outermost layer
  exe 'hi '.s:basename.'6c ctermfg=darkred     guifg=red'

  " helper function
  func s:DoSyn(cur, top, left, right, uniq)
    let uniq = a:uniq
    if exists("g:rainbow_nested") && g:rainbow_nested != 0
      let uniq = ""
    endif

    let cmd = 'syn region '.s:basename.uniq.a:cur.' transparent fold matchgroup='.s:basename.a:cur.'c start=/'.a:left.'/ end=/'.a:right.'/ contains=TOP'

    let i = a:cur

    if i == 1
      let i = a:top
    endif

    while i <= a:top
      let cmd = cmd . ',' . s:basename . uniq . i
      let i = i + 1
    endwhile
    exe cmd
  endfunc

  func s:DoSyntaxes(count)
    let i = 1

    while i <= a:count
      " if you define new pairs, make sure to take into account that the
      " delimiter is currently / and that it uses regex, so you need to escape
      " regex metachars (like what is done for brackets)

      if exists("g:rainbow_paren") && g:rainbow_paren != 0
        " ocaml uses (* *) for comments; these shouldn't be highlighted
        if &filetype == "ocaml"
          call s:DoSyn(i, a:count, "(\\*\\@!", "\\*\\@<!)", "a")
        else
          call s:DoSyn(i, a:count, "(", ")", "a")
        endif
      endif

      if exists("g:rainbow_brace") && g:rainbow_brace != 0
        call s:DoSyn(i, a:count, "{", "}", "b")
      endif

      if exists("g:rainbow_bracket") && g:rainbow_bracket != 0
        call s:DoSyn(i, a:count, "\\[", "\\]", "c")
      endif

      if exists("g:rainbow_angle") && g:rainbow_angle != 0
        call s:DoSyn(i, a:count, "<", ">", "d")
      endif

      let i = i + 1
    endwhile
  endfun

  call s:DoSyntaxes(6) " 6 is the number of colors we have

  delfun s:DoSyn
  delfun s:DoSyntaxes
endfunction

if exists("g:rainbow") && g:rainbow
  augroup rainbow
    autocmd BufWinEnter,FileType * call Rainbow()
  augroup END
endif
