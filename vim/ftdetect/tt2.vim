au BufNewFile,BufRead *.tt
        \ if ( getline(1) . getline(2) . getline(3) =~ '<\chtml'
        \           && getline(1) . getline(2) . getline(3) !~ '<[%?]' )
        \   || getline(1) =~ '<!DOCTYPE HTML'
        \ || ( getline(1) . getline(2) . getline(3) =~ '<.*>' ) |
        \   setf tt2html |
        \ else |
        \   setf tt2 |
        \ endif
