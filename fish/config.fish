# environment {{{
function export
    set parts (string split -m1 = $argv[1])
    set -x $parts[1] $parts[2]
end
source (cat ~/.env | sed 's/\$(/(/g' | psub)
# }}}
# language environments {{{
test -f $HOME/perl5/perlbrew/etc/bashrc; and source $HOME/perl5/perlbrew/etc/perlbrew.fish
type rbenv > /dev/null 2>&1; and source (rbenv init - | psub)
# }}}
# Change the window title of X terminals {{{
function fish_title
    echo "$USER@"(hostname)":"(echo $PWD | sed "s,^$HOME,~,")
end
# }}}
# aliases {{{
source $HOME/.aliases
# }}}
# fortune {{{
if status --is-interactive
    fortune -n600 -s ~/.fortune | grep -v -E '^$'
end
# }}}
