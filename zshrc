# language environments {{{
test -f $HOME/perl5/perlbrew/etc/bashrc && source $HOME/perl5/perlbrew/etc/bashrc
test -f $HOME/python/bin/activate && source $HOME/python/bin/activate
type rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"
test -d $HOME/.cargo/bin && export PATH="$HOME/.cargo/bin:$PATH"
# }}}
# environment {{{
# not using .zshenv, because it runs before /etc/profile, and /etc/profile
# tends to hard-set $PATH and such
[ -d /usr/share/git/diff-highlight ] && export PATH="/usr/share/git/diff-highlight:${PATH}"
[ -d /usr/local/share/git-core/contrib/diff-highlight ] && export PATH="/usr/local/share/git-core/contrib/diff-highlight:${PATH}"
export PATH="${HOME}/.bin/local:${HOME}/.bin/$(hostname):${HOME}/.bin:/usr/lib/ccache/bin:$PATH"
[ -f "$HOME/.config/sh/env" ] && source $HOME/.config/sh/env
# }}}
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
[ -f "$HOME/.config/sh/aliases" ] && source $HOME/.config/sh/aliases
[ -f "$HOME/.config/sh/functions" ] && source $HOME/.config/sh/functions
# }}}
# completion {{{
fpath=(~/.config/zsh/local-completions/$(hostname) ~/.config/zsh/local-completions ~/.config/zsh/zsh-completions/src $fpath)
source ~/.zshcomplete
# }}}
# zsh configuration {{{
source ~/.zshinput
autoload -U colors
colors
setopt incappendhistory
setopt extendedhistory
setopt histignoredups
setopt noclobber
setopt nobeep
setopt completeinword
setopt correct
export REPORTTIME=120
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [ynae] "
export KEYTIMEOUT=5
# plugins {{{
# cdhist {{{
source ~/.config/sh/cdhist.sh
# }}}
# zsh-syntax-highlighting {{{
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue,underline'
ZSH_HIGHLIGHT_STYLES[path_approx]='underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[history-expansion]='none'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'
# }}}
# zsh-autosuggestions {{{
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
# }}}
# vim-history-sync {{{
source ~/.vim/pack/plugins/start/history-sync/sh/history-sync.zsh
# }}}
# }}}
# prompt {{{
if type fancy-prompt > /dev/null 2>&1; then
    function shell_prompt_precmd () {
        PROMPT=`fancy-prompt --prompt-escape zsh $?`
        RPS1=''
    }
    precmd_functions+=(shell_prompt_precmd)
fi
function zle-keymap-select () {
    setopt localoptions no_ksharrays
    { [[ "${@[2]-main}" == opp ]] } && return
    if [[ "x$KEYMAP" == 'xmain' ]]; then
        RPS1=''
    else
        RPS1="%{$fg_bold[yellow]%}[${KEYMAP/vicmd/NORMAL}]%{$reset_color%}"
    fi
    zle reset-prompt
}
zle -N zle-keymap-select
# }}}
# }}}
# fortune {{{
fortune -n600 -s ~/.local/share/fortune | grep -v -E "^$"
# }}}
# vim: fdm=marker
