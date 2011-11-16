" the perl ftplugin hard-sets path, so this has to go in after/
setlocal path+=lib

function! s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfun
fun! s:StringFilter(list,string)
    let string = substitute(a:string,"'","''",'g')
    return filter(copy(a:list),"stridx(v:val,'".string."') == 0 && v:val != '".string."'" )
endf
function! s:CompMooseTC(base, context)
    let words = ['subtype', 'class_type', 'role_type', 'maybe_type',
                \'duck_type', 'enum', 'union', 'as', 'where', 'message',
                \'inline_as', 'optimize_as', 'type', 'match_on_type',
                \'coerce', 'from', 'via', 'find_type_constraint',
                \'register_type_constraint']
    return s:StringFilter(words, a:base)
endfunction
call AddPerlOmniRule({
    \'contains': 'use Moose::Util::TypeConstraints',
    \'context':  '.*',
    \'backward': '\<\w*$',
    \'comp':     function(s:SID() . 'CompMooseTC')
\})
