highlight clear
syntax reset
set background=dark
let g:colors_name = expand('<sfile>:t:r')

let s:g = {
    \"black":         "#000000",
    \"red":           "#ed5f74",
    \"green":         "#1ea672",
    \"yellow":        "#d97917",
    \"blue":          "#688ef1",
    \"magenta":       "#c96ed0",
    \"cyan":          "#3a97d4",
    \"white":         "#e3e8ee",
    \"brightblack":   "#697386",
    \"brightred":     "#fbb5b2",
    \"brightgreen":   "#85d996",
    \"brightyellow":  "#efc078",
    \"brightblue":    "#9fcdff",
    \"brightmagenta": "#f0b4e4",
    \"brightcyan":    "#7fd3ed",
    \"brightwhite":   "#ffffff",
    \"darkblack":     "#000000",
    \"darkred":       "#742833",
    \"darkgreen":     "#00643c",
    \"darkyellow":    "#6e3500",
    \"darkblue":      "#2c4074",
    \"darkmagenta":   "#602864",
    \"darkcyan":      "#144c71",
    \"darkwhite":     "#3e4043",
    \"darkerwhite":   "#090e14",
\}

let s:c = {
    \"black":         "0",
    \"red":           "1",
    \"green":         "2",
    \"yellow":        "3",
    \"blue":          "4",
    \"magenta":       "5",
    \"cyan":          "6",
    \"white":         "7",
    \"brightblack":   "8",
    \"brightred":     "9",
    \"brightgreen":   "10",
    \"brightyellow":  "11",
    \"brightblue":    "12",
    \"brightmagenta": "13",
    \"brightcyan":    "14",
    \"brightwhite":   "15",
\}

function s:hi(name, fg, bg)
    if a:fg == ""
        let ctermfg = ""
        let guifg = ""
    elseif a:fg =~ "^#"
        let ctermfg = ""
        let guifg = "guifg=" . a:fg
    else
        let ctermfg = "ctermfg=" . s:c[a:fg]
        let guifg = "guifg=" . s:g[a:fg]
    endif

    if a:bg == ""
        let ctermbg = ""
        let guibg = ""
    elseif a:bg =~ "^#"
        let ctermbg = ""
        let guibg = "guibg=" . a:bg
    else
        let ctermbg = "ctermbg=" . s:c[a:bg]
        let guibg = "guibg=" . s:g[a:bg]
    endif

    silent exe "highlight clear " . a:name
    if a:fg != "" || a:bg != ""
        silent exe "highlight " . a:name . " " . ctermfg . " " . ctermbg . " " . guifg . " " . guibg
    endif
endfunction

" text
call <sid>hi("Comment", "brightblack", "")
call <sid>hi("Constant", "red", "")
call <sid>hi("Delimiter", "blue", "")
call <sid>hi("Error", "black", "brightmagenta")
call <sid>hi("Function", "brightcyan", "")
call <sid>hi("Identifier", "", "")
call <sid>hi("Include", "blue", "")
call <sid>hi("Operator", "", "")
call <sid>hi("PreProc", "magenta", "")
call <sid>hi("Special", "magenta", "")
call <sid>hi("SpecialKey", "magenta", "")
call <sid>hi("Statement", "yellow", "")
call <sid>hi("Title", "magenta", "")
call <sid>hi("Todo", "black", "brightyellow")
call <sid>hi("Type", "green", "")

autocmd FileType go call <sid>hi("goBuiltins", "yellow", "")
autocmd FileType go call <sid>hi("goFunctionCall", "brightcyan", "")
autocmd FileType markdown call <sid>hi("mkdListItem", "yellow", "")
autocmd FileType perl call <sid>hi("Identifier", "brightcyan", "")
autocmd FileType puppet call <sid>hi("puppetStringDelimiter", "red", "")
autocmd FileType ruby call <sid>hi("rubyInterpolationDelimiter", "magenta", "")
autocmd FileType ruby call <sid>hi("rubyPercentStringDelimiter", "yellow", "")
autocmd FileType ruby call <sid>hi("rubyStringDelimiter", "red", "")
autocmd FileType ruby call <sid>hi("rubyRegexDelimiter", "red", "")
autocmd FileType sh call <sid>hi("shQuote", "red", "")
autocmd FileType vim call <sid>hi("vimBracket", "magenta", "")
autocmd FileType vim call <sid>hi("vimMapMod", "magenta", "")

" ui
call <sid>hi("DiffAdd", "", s:g["darkgreen"])
call <sid>hi("DiffChange", "", s:g["darkblue"])
call <sid>hi("DiffDelete", "", s:g["darkred"])
call <sid>hi("DiffText", "", s:g["darkmagenta"])
call <sid>hi("Folded", "brightgreen", s:g["darkgreen"])
call <sid>hi("MatchParen", "brightcyan", s:g["darkcyan"])
call <sid>hi("MoreMsg", "green", s:g["darkgreen"])
call <sid>hi("NonText", "brightblue", s:g["darkerwhite"])
call <sid>hi("Search", "", s:g["darkmagenta"])
call <sid>hi("SpellBad", "", s:g["darkred"])
call <sid>hi("SpellCap", "", s:g["darkblue"])
call <sid>hi("SpellRare", "", s:g["darkgreen"])
call <sid>hi("SpellLocal", "", s:g["darkmagenta"])
call <sid>hi("Visual", "", s:g["darkwhite"])
