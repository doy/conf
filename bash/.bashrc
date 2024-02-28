# language environments {{{
test -d "$HOME/.cargo/bin" && export PATH="$HOME/.cargo/bin:$PATH"
# }}}
# environment {{{
PATH="${HOME}/.bin/local:${HOME}/.bin/$(hostname):${HOME}/.bin:$PATH"
export PATH
# }}}
# Test for an interactive shell. {{{
# There is no need to set anything past this point for scp and rcp, and it's
# important to refrain from outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi
[ -z "$PS1" ] && return
# }}}
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
# shellcheck source=sh/.config/sh/fzf/shell/completion.bash
source ~/.config/sh/fzf/shell/completion.bash
# shellcheck source=sh/.config/sh/fzf/shell/key-bindings.bash
source ~/.config/sh/fzf/shell/key-bindings.bash
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
