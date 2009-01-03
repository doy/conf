" :make does a syntax check
setlocal makeprg=luac\ -p\ %
setlocal errorformat=luac:\ %f:%l:\ %m

" set commentstring
setlocal commentstring=--%s

" treat require lines as include lines (for tab completion, etc)
setlocal include=\\s*require\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'
exe "setlocal path=" . system("lua -e 'local fpath = \"\" for path in package.path:gmatch(\"[^;]*\") do if path:match(\"\?\.lua$\") then fpath = fpath .. path:gsub(\"\?\.lua$\", \"\") .. \",\" end end print(fpath:gsub(\",,\", \",.,\"):sub(0, -2))'")
