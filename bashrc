# notes {{{
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !
# }}}
# environment {{{
[ -f "$HOME/.env" ] && source $HOME/.env
# }}}
# Test for an interactive shell. {{{
# There is no need to set anything past this point for scp and rcp, and it's
# important to refrain from outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi
[ -z "$PS1" ] && return # }}}
# Enable colors for ls, etc.  Prefer ~/.dir_colors {{{
if [[ -f ~/.dir_colors ]]; then
	eval `dircolors -b ~/.dir_colors`
elif [[ -f /etc/DIR_COLORS ]]; then
	eval `dircolors -b /etc/DIR_COLORS`
else
	eval `dircolors -b`
fi # }}}
# Change the window title of X terminals {{{
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome|screen*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
esac # }}}
# aliases {{{
[ -f "$HOME/.aliases" ] && source $HOME/.aliases
# }}}
# external files {{{
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
source ~/.sh/cdhist.sh
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
# prompt {{{
export PROMPT_COMMAND="__err=\$?;$PROMPT_COMMAND;PS1=\"\$(fancy-prompt --prompt-escape bash "\$__err")\""
# }}}
# set the correct perl {{{
if type -a perlbrew > /dev/null 2>&1; then
    function _setup_perlbrew {
        local perl=$PERLBREW_PERL
        [ -z $perl ] && perl="$(readlink ${HOME}/perl5/perlbrew/perls/current)"
        local pwd="${PWD#${HOME}}/"
        if [[ "${pwd:0:6}" == "/work/" ]]; then
            if [[ "$perl" != "work-perl" ]]; then
                perlbrew use work-perl
            fi
        else
            if [[ "$perl" == "work-perl" ]]; then
                perlbrew use perl-5.10.1
            fi
        fi
    }
    export PROMPT_COMMAND="${PROMPT_COMMAND};_setup_perlbrew"
fi
# }}}
# }}}
# fortune {{{
fortune -n300 -s ~/.fortune | grep -v -E "^$"
# }}}
