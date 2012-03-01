# environment {{{
# not using .zshenv, because it runs before /etc/profile, and /etc/profile
# tends to hard-set $PATH and such
[ -f "$HOME/.env" ] && source $HOME/.env
# }}}
# Enable colors for ls, etc.  Prefer ~/.dir_colors {{{
if [[ -f ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
elif [[ -f /etc/DIR_COLORS ]]; then
    eval `dircolors -b /etc/DIR_COLORS`
else
    eval `dircolors -b`
fi # }}}
# Change the window title of X terminals {{{
function term_title_precmd () {
    echo -ne "\033]0;${USER}@${HOST}:${PWD/$HOME/~}\007"
}
case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome|screen*)
        precmd_functions+=(term_title_precmd)
        ;;
esac # }}}
# aliases {{{
[ -f "$HOME/.aliases" ] && source $HOME/.aliases
# }}}
# external files {{{
source ~/.zshcomplete
source ~/.zshinput
# }}}
# zsh configuration {{{
autoload -U colors
colors
setopt sharehistory
setopt extendedhistory
setopt histignoredups
setopt nobeep
setopt completeinword
setopt correct
export REPORTTIME=120
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [ynae] "
# plugins {{{
# cdhist {{{
source ~/.sh/cdhist.sh
# }}}
# zsh-syntax-highlighting {{{
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
# }}}
# }}}
# prompt {{{
function shell_prompt_precmd () {
    PROMPT=`fancy-prompt --prompt-escape zsh $?`
}
precmd_functions+=(shell_prompt_precmd)
# }}}
# set the correct perl {{{
if type perlbrew > /dev/null 2>&1; then
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
                perlbrew use perl-5.14.2
            fi
        fi
    }
    precmd_functions+=(_setup_perlbrew)
fi
# }}}
# }}}
# fortune {{{
fortune -n300 -s ~/.fortune | grep -v -E "^$"
# }}}
