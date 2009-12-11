# notes {{{
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !
# }}}
# environment {{{
export PATH="~/.bin/marathon:~/.bin/nethack:~/.bin:/usr/local/sbin:/usr/local/bin:$PATH"
export MPD_HOST=bishamon
export LUA_CPATH='/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?/init.so;./?.so'
export LUA_PATH='/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;?.lua'
export MANPAGER="${HOME}/.bin/vimmanpager"
export EDITOR='/usr/bin/vim'
export SVN_SSH="${HOME}/.bin/ssh"
export DARCS_SSH="${HOME}/.bin/ssh"
export DARCS_SCP="${HOME}/.bin/scp"
export DARCS_SFTP="${HOME}/.bin/sftp"
export GIT_SSH="${HOME}/.bin/ssh"
export RSYNC_RSH="${HOME}/.bin/ssh"
export PERL5LIB="${HOME}/.perl:${HOME}/.perl/lib/perl5/site_perl/5.10.0/i686-linux"
export CVS_RSH='ssh'
export TEXINPUTS=".:${HOME}/conf/tex:"
export NHBOT_DARCS_AUTHOR="doy@tozt.net"
export NHBOT_PUBLIC_REPO_BASE="http://tozt.net/code/"
export LESS='-QR'
[ -x `which git` ] && export GIT_EXEC_PATH="${HOME}/.bin/git:"`git --exec-path`
[ -x /usr/bin/lesspipe ] && export LESSOPEN='|/usr/bin/lesspipe %s'
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN='|/usr/bin/lesspipe.sh %s'
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
	xterm*|rxvt*|Eterm|aterm|kterm|gnome|screen*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
        #screen*)
                #PROMPT_COMMAND='echo -ne "\033k${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
                #;;
esac # }}}
# aliases {{{
# adding options to common commands {{{
alias ls="ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias bc="bc -lq"
alias ncmpc="ncmpc -c"
alias truecrypt="sudo truecrypt -t"
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
alias apt='ssh doy@apt.tozt.net'
alias jjaro="ssh doy@jjaro.net"
alias tozt="ssh doy@tozt.net"
alias csil="(TERM=rxvt ssh jluehrs2@csil-core7.cs.uiuc.edu)"
alias ews="ssh jluehrs2@remlnx.ews.uiuc.edu"
alias henzell="ssh henzell@crawl.akrasiac.org"
# }}}
# other {{{
alias wgetff='wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070404 Firefox/2.0.0.3"'
alias ..='cd ..'
alias dotperl='rsync -av lib/* ~/.perl/'
function luado { # thanks rici
    local e=$1
    shift
    lua /dev/fd/3 $* 4<&0- <<<$e 3<&0- 0<&4-
}
function setfont {
    printf '\e]710;%s\007' "$1"
}
function mem_usage {
    ps -eo size,ucmd | sort -rn | head -n$([ -z "$1" ] && echo 20 || echo $1)
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
function nopaste_moose {
    nopaste --chan=#moose --services=Shadowcat --desc="$1"
}
function gist {
    nopaste --services=Gist --desc="$1"
}
function fm22avi {
    fceux --playmov $1.fm2 --sound 1 --soundq 1 --soundrate 48000 --nospritelim 1 --pal 0 --xscale 1 --yscale 1 --opengl 0 --special 0 $2 --videolog "mencoder - -o $1.avi -ovc x264 -x264encopts qp=0 -oac mp3lame -lameopts mode=3:preset=128 -noskip -nocache -mc 0 -aspect 4/3 NESVSETTINGS"
}
function pdfcat {
    local out=$1
    shift
    gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$out $*
}
function vack {
    vim $(ack -la -- $*)
}
function github-clone {
    git clone git://github.com/$1/$2.git
}
function mod {
    yes | module-setup $1
}
function svup {
    svc -u "$HOME/.services/$1"
    svstat "$HOME/.services/$1"
}
function svdn {
    svc -d "$HOME/.services/$1"
    svstat "$HOME/.services/$1"
}
function svst {
    svstat "$HOME/.services/$1"
}
# }}}
# }}}
# bash configuration {{{
source ~/.bash/colors
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
function _set_error {
    __error=$(printf %03d $?)
    if [[ "x${__error//0/}" != "x" ]]; then
        __error_color=$HIRED
    else
        __error_color=$NORM
    fi
}
function _set_vcs {
    local vcs
    local vcs_dirty
    local vcs_branch
    local vcs_dir
    local vcs_state
    local vcs_local_commits
    __vcs=''
    function _find_upwards {
        local pwd
        pwd=$(pwd)
        while [[ -n "$pwd" ]]; do
            if [[ -d "$pwd/$1" ]]; then
                return 0
            fi
            pwd=${pwd%/*}
        done
        return 1
    }
    function _find_svn {
        [[ -d '.svn' ]] || return 1
        vcs='svn'
    }
    function _find_darcs {
        if _find_upwards '_darcs'; then
            vcs='darcs'
            return 0
        fi
        return 1
    }
    function _find_git {
        if _find_upwards '.git'; then
            vcs='git'
            return 0
        fi
        return 1
    }

    _find_svn || _find_darcs || _find_git

    case "$vcs" in
        svn)
            vcs_dirty=$([[ -n "$(svn status | grep -v '^?')" ]]; echo $?)
            vcs_branch=
        ;;
        darcs)
            vcs_dirty=$(darcs whatsnew > /dev/null 2>&1; echo $?)
            vcs_branch=
        ;;
        git)
            local git_dir
            local git_base
            git_dir=$(git rev-parse --git-dir)
            vcs_branch=$(git symbolic-ref -q HEAD 2>/dev/null)
            if [[ -z "$(git ls-files -udm)" ]]; then
                vcs_dirty=1
            else
                vcs_dirty=0
            fi
            if [[ -z "${vcs_branch}" ]]; then
                vcs_branch=$(git rev-parse --short HEAD)
            else
                vcs_branch=${vcs_branch#refs/heads/}
                git_base=$(git merge-base HEAD origin/$vcs_branch)
                if [[ "${git_base}" == "$(git rev-parse HEAD)" ]]; then
                    vcs_local_commits="-$(git rev-list HEAD..origin/$vcs_branch | wc -l)"
                elif [[ "${git_base}" == "$(git rev-parse origin/$vcs_branch)" ]]; then
                    vcs_local_commits="+$(git rev-list origin/${vcs_branch}..HEAD | wc -l)"
                else
                    vcs_local_commits="+$(git rev-list ${git_base}..HEAD | wc -l)-$(git rev-list ${git_base}..origin/$vcs_branch | wc -l)"
                fi
            fi
            if [[ -e "${git_dir}/MERGE_HEAD" ]]; then
                vcs_state='merge'
            fi
            if [[ -d "${git_dir}/rebase-apply" || -d "${git_dir}/rebase-merge" ]]; then
                vcs_state='rebase'
            fi
            if [[ "x$vcs_branch" == "xmaster" ]]; then
                vcs_branch=''
            fi
        ;;
        *) return 0 ;;
    esac
    if [[ "$vcs_dirty" -eq 0 ]]; then
        vcs_dirty='*'
    else
        vcs_dirty=''
    fi
    if [[ -n "$vcs_branch" ]]; then
        vcs_branch=":$vcs_branch"
    fi
    if [[ -n "$vcs_state" ]]; then
        vcs_state="(${vcs_state:0:1})"
    fi
    if [[ "$vcs_local_commits" == "-0" ]]; then
        vcs_local_commits=''
    fi
    __vcs="(${vcs:0:1}${vcs_dirty}${vcs_branch}${vcs_local_commits}${vcs_state})"
}
export PROMPT_COMMAND="_set_error;_set_vcs;$PROMPT_COMMAND"
export PS1="\[\$__error_color\]\$__error \[${HIYELLOW}\][\t] \[${HIGREEN}\]\u@\h \[${HIBLUE}\]\W\[${CYAN}\]\$__vcs \[${HIBLUE}\]\\$\[${NORM}\] "
# }}}
# }}}
# external files {{{
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
source ~/.bash/cdhist.sh
source ~/.bash/j.sh
# }}}
# fortune {{{
fortune -n300 -s ~/.fortune | grep -v -E "^$"
# }}}
