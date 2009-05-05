" See http://www.vim.org/scripts/script.php?script_id=1318
" Written by Sartak, feel free to add your own!

if !exists('loaded_snippet') || &cp
    finish
endif

source ~/.vim/after/ftplugin/moose_snippets.vim

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet for for my \$".st."var".et." (".st."list".et.") {<CR>".st.et."<CR>}<CR>"
exec "Snippet fore for my \$".st."var".et." (@".st."array".et.") {<CR>".st.et."<CR>}<CR>"
exec "Snippet fori for (my \$".st."var".et." = 0; \$".st."var".et." < ".st."expression".et."; ++\$".st."var".et.") {<CR>".st.et."<CR>}<CR>"
exec "Snippet eval eval {<CR>".st.et."<CR>};<CR><CR>if ($@) {<CR>".st.et."<CR>}<CR>"
exec "Snippet st map { $_->[0] }<CR>sort { $a->[1] ".st."cmp".et." $b->[1] }<CR>map { [$_, ".st."function".et."] }<CR>".st."list".et
