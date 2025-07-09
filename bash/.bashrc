if [[ $- != *i* ]]; then
    return
fi
for file in ~/.config/sh/rc.d/*; do
    # shellcheck disable=SC1090
    source "$file"
done
# completion {{{
#shellcheck disable=SC1091
[ -f /etc/bash_completion ] && source /etc/bash_completion
#shellcheck disable=SC1091
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
#shellcheck disable=SC1091
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
# }}}
# bash configuration {{{
shopt -s extglob
shopt -s no_empty_cmd_completion
shopt -s checkwinsize
shopt -s histappend
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar
fi
set -o vi
export HISTCONTROL=ignoredups
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
if [[ -z "$PROMPT_COMMAND" ]]; then
    export PROMPT_COMMAND='history -a'
else
    export PROMPT_COMMAND="${PROMPT_COMMAND};history -a"
fi
# plugins {{{
if type fzf > /dev/null 2>&1; then
    eval "$(fzf --bash)"
fi
# }}}
# prompt {{{
if type starship > /dev/null 2>&1; then
    eval "$(starship init bash)"
fi
# }}}
# }}}
# fortune {{{
fortune -n600 -s ~/.local/share/fortune | grep -v -E "^$"
# }}}
# vim: fdm=marker
