# environment {{{
export PATH="/usr/share/git/diff-highlight:${HOME}/.bin/local:${HOME}/.bin:/usr/lib/ccache/bin:$PATH"
[ -f "$HOME/.env" ] && source $HOME/.env
# }}}
# language environments {{{
test -f $HOME/perl5/perlbrew/etc/bashrc && source $HOME/perl5/perlbrew/etc/bashrc
test -f $HOME/python/bin/activate && source $HOME/python/bin/activate
type rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"
test -d $HOME/.cargo/bin && export PATH="$HOME/.cargo/bin:$PATH"
# }}}
# Test for an interactive shell. {{{
# There is no need to set anything past this point for scp and rcp, and it's
# important to refrain from outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi
[ -z "$PS1" ] && return # }}}
# Change the window title of X terminals {{{
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome|screen*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
esac # }}}
# aliases {{{
[ -f "$HOME/.aliases" ] && source $HOME/.aliases
[ -f "$HOME/.functions" ] && source $HOME/.functions
# }}}
# completion {{{
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
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
source ~/.sh/cdhist.sh
# }}}
# prompt {{{
export PROMPT_COMMAND="__err=\$?;$PROMPT_COMMAND;PS1=\"\$(fancy-prompt --prompt-escape bash "\$__err")\""
# }}}
# }}}
# fortune {{{
fortune -n600 -s ~/.fortune | grep -v -E "^$"
# }}}
# vim: fdm=marker
