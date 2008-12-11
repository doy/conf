# notes {{{
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !
# }}}
# Test for an interactive shell. {{{
# There is no need to set anything past this point for scp and rcp, and it's
# important to refrain from outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi
[ -z "$PS1" ] && return # }}}
# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489 {{{
if [[ -f ~/.dir_colors ]]; then
	eval `dircolors -b ~/.dir_colors`
elif [[ -f /etc/DIR_COLORS ]]; then
	eval `dircolors -b /etc/DIR_COLORS`
else
	eval `dircolors -b`
fi # }}}
# Change the window title of X terminals {{{
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac # }}}
# aliases {{{
# adding options to common commands {{{
alias ls="ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias bc="bc -l"
alias ncmpc="ncmpc -c"
alias truecrypt="sudo truecrypt -t"
alias darcs="ssh-key-unlock && rlwrap darcs"
# }}}
# games {{{
alias nao="(TERM=rxvt telnet nethack.alt.org)"
alias cao="(TERM=rxvt /usr/bin/ssh -C -i ~/.ssh/cao_key joshua@crawl.akrasiac.org)"
alias cdo="ssh -C -i ~/.ssh/cao_key crawl@crawl.develz.org"
alias scn="(TERM=xterm-color telnet slashem.crash-override.net)"
alias spork="telnet sporkhack.nineball.org"
alias cgoban="javaws http://files.gokgs.com/javaBin/cgoban.jnlp"
alias counterstrike="wine c:\\Program\ Files\\Sierra\\Half-Life\\hl.exe -game cstrike -console -numericping -nojoy -noipx"
alias halflife="wine c:\\Program\ Files\\Sierra\\Half-Life\\hl.exe" # -console breaks
alias starcraft="wine c:\\Program\ Files\\Starcraft\\StarCraft.exe"
# }}}
# termcast {{{
alias tc="telnet termcast.org"
# }}}
# shells {{{
alias apt='ssh $(wget -O- http://jjaro.net/house/ip 2>/dev/null)'
alias jjaro="ssh jjaro.net"
alias tozt="ssh tozt.net"
alias csil="(TERM=rxvt ssh jluehrs2@csil-core7.cs.uiuc.edu)"
alias ews="ssh jluehrs2@remlnx.ews.uiuc.edu"
alias henzell="ssh henzell@crawl.akrasiac.org"
# }}}
# other {{{
alias wgetff='wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070404 Firefox/2.0.0.3"'
alias getsong="mpc | head -n1"
function luado { # thanks rici
    local e=$1
    shift
    lua /dev/fd/3 $* 4<&0- <<<$e 3<&0- 0<&4-
}
function setfont {
    printf '\e]710;%s\007' "$1"
}
function checkmessages {
    find ~/.purple/logs/ -mmin -$1 -type f | grep -v .system | xargs tail -n $2
}
function lastaim {
    pushd ~/.purple/logs/aim/thedoyster/$1 > /dev/null
    less $(ls | tail -n1)
    popd > /dev/null
}
function mem_usage {
    ps -eo size,ucmd | sort -rn | head -n$([ -z "$1" ] && echo 20 || echo $1)
}
function installed_kernel_modules {
    find /lib/modules/$([ -z "$1" ] && echo $(uname -r) || echo $1)/ \
        -iname '*.ko' | sed 's:.*/\(.*\)\.ko:\1:'
}
function opened_files {
    strace $* 2>&1 | grep -E '^open\('   | \
                     grep -v ENOENT      | \
                     grep -v O_DIRECTORY | \
                     cut -f2 -d"\"" | \
                     grep -vE '^/proc/'  | \
                     grep -v '^/sys/'    | \
                     grep -v '^/dev/'
}
function alert {
    echo "DISPLAY=$DISPLAY xmessage -center -default okay $1" | at $2
}
# }}}
# }}}
# bash configuration {{{
shopt -s extglob
shopt -s no_empty_cmd_completion
shopt -s checkwinsize
shopt -s histappend
set -o vi
export HISTCONTROL=ignoredups
export PATH="~/.bin/marathon:~/.bin/nethack:~/.bin:${PATH}:/usr/local/sbin:/usr/local/bin"
export PS1='$(_tmp=$(printf %03d $?); echo "${_tmp/*[1-9]*/\[\033[1;31;40m\]$_tmp\[\033[m\]}" "\[\033[01;33m\][\t] \[\033[01;32m\]\u@\h\[\033[01;34m\] \W $\[\033[00m\] ")'
if [[ -z "$PROMPT_COMMAND" ]]; then
    export PROMPT_COMMAND='history -a'
else
    export PROMPT_COMMAND="${PROMPT_COMMAND};history -a"
fi
# }}}
# environment {{{
export MPD_HOST=demogorgon
export LUA_CPATH='/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?/init.so;./?.so'
export LUA_PATH='/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;?.lua'
export MANPAGER='/home/doy/.bin/vimmanpager'
export EDITOR='/usr/bin/vim'
export DARCS_SSH='/home/doy/.bin/ssh'
export DARCS_SCP='/home/doy/.bin/scp'
export DARCS_SFTP='/home/doy/.bin/sftp'
export PERL5LIB='/home/doy/.perl/:/home/doy/.perl/lib/perl5/site_perl/5.10.0/i686-linux/'
export CVS_RSH='ssh'
export TEXINPUTS=".:~/conf/tex:"
[ -x /usr/bin/lesspipe ] && export LESSOPEN='|/usr/bin/lesspipe %s'
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN='|/usr/bin/lesspipe.sh %s'
# }}}
# external files {{{
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
[ -f "~/.keychain/${HOSTNAME}-sh" ] && source "~/.keychain/${HOSTNAME}-sh"
# }}}
# fortune {{{
fortune -n300 -s ~/.fortune | grep -v -E "^$"
# }}}
