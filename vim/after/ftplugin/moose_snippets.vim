" See http://www.vim.org/scripts/script.php?script_id=1318
" Written by Sartak and doy, feel free to add your own!

if !exists('loaded_snippet') || &cp
    finish
endif

function! RemoveUnchangedLine()
    if match(getline('.'), "<{}>") >= 0
        normal! dd
        return ''
    else
        return @z
    endif
endfun

function! Snippet(abbr, str)
    if type(a:str) == type([])
        return Snippet(a:abbr, join(a:str, "\n"))
    endif
    let st = g:snip_start_tag
    let et = g:snip_end_tag
    let cd = g:snip_elem_delim
    let str = substitute(a:str, '<{.\{-}\zs:\ze.\{-}}>', cd, "")
    let str = substitute(str, '<{', st, "")
    let str = substitute(str, '}>', et, "")
    exec 'Snippet '.a:abbr.' '.str
endfunction

function! SnippetFile(filename)
    let abbr = fnamemodify(a:filename, ':t:r')
    let str = readfile(a:filename)
    return Snippet(abbr, str)
endfunction

call Snippet('class', [
            \"package <{ClassName}>;",
            \"use Moose;",
            \"",
            \"extends '<{SuperClass:RemoveUnchangedLine()}>;",
            \"",
            \"<{}>",
            \"",
            \"__PACKAGE__->meta->make_immutable;",
            \"no Moose;",
            \"",
            \"1;"])
call Snippet('has', [
            \"has <{attr}> => (",
            \    "is  => '<{rw}>',",
            \    "isa => '<{Str}>',",
            \    "<{options:RemoveUnchangedLine()}>",
            \");"])
call Snippet('hasl', [
            \"has <{attr}> => (",
            \    "is         => '<{rw}>',",
            \    "isa        => '<{Str}>',",
            \    "lazy_build => 1,",
            \    "<{options:RemoveUnchangedLine()}>",
            \");",
            \"",
            \"sub _build_<{attr}> {",
            \    "my $self = shift;",
            \    "<{}>",
            \"}"])
call Snippet('sub', [
            \"sub <{name}> {",
            \    "my $self = shift;",
            \    "my (<{arg:RemoveUnchangedLine()}>) = @_;",
            \    "<{}>",
            \"}"])
call Snippet('around', [
            \"around <{name}> => sub {",
            \    "my $<{next}> = shift;",
            \    "my $self = shift;",
            \    "<{}>",
            \"};"])
call Snippet('before', [
            \"before <{name}> => sub {",
            \    "my $self = shift;",
            \    "<{}>",
            \"};"])
call Snippet('after', [
            \"after <{name}> => sub {",
            \    "my $self = shift;",
            \    "<{}>",
            \"};"])

"for file in globpath(&rtp, 'snippets/*')
    "call SnippetFile(file)
"endfor
