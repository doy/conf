au BufNewFile,BufRead *.tt
        \ if ( join(getline(1, 10)) =~ '<\chtml'
        \           && join(getline(1, 10)) !~ '<[%?]' )
        \   || getline(1) =~ '<!DOCTYPE HTML'
        \ || ( join(getline(1, 10)) =~ '<.*>' ) |
        \   setf tt2html |
        \ else |
        \   setf tt2 |
        \ endif
