" See http://www.vim.org/scripts/script.php?script_id=1318
" Written by Sartak, feel free to add your own!

if !exists('loaded_snippet') || &cp
    finish
endif

source ~/.vim/after/ftplugin/moose_snippets.vim

call Snippet('if', [
            \"if (<{cond}>) {",
            \    "<{}>",
            \"}"])
call Snippet('elsif', [
            \"elsif (<{cond}>) {",
            \    "<{}>",
            \"}"])
call Snippet('else', [
            \"else {",
            \    "<{}>",
            \"}"])
call Snippet('for', [
            \"for my $<{var}> (<{list}>) {",
            \    "<{}>",
            \"}"])
call Snippet('fora', [
            \"for my $<{var}> (@<{array}>) {",
            \    "<{}>",
            \"}"])
call Snippet('fori', [
            \"for (my $<{var}> = 0; $<{var}> < <{expr}>; ++$<{var}>) {",
            \    "<{}>",
            \"}"])
call Snippet('eval', [
            \"eval {<{}>};",
            \"if ($@) {",
            \    "<{}>",
            \"}"])
call Snippet('st', [
            \"map { $_->[0] }",
            \"sort { $a->[1] <{cmp}> $b->[1] }",
            \"map { [$_, <{function}>] }",
            \"<{list}>"])
call Snippet('tbl', [
            \"local $Test::Builder::Level = $Test::Builder::Level + 1;",
            \"<{}>"])
call Snippet('ccl', [
            \"local $Carp::CarpLevel = Carp::CarpLevel + 1;",
            \"<{}>"])
