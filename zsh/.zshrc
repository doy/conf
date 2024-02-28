for file in ~/.config/sh/rc.d/*; do
    # shellcheck disable=SC1090
    source "$file"
done
# completion {{{
# shellcheck disable=SC2206
fpath=( \
    "${HOME}/.config/zsh/local-completions/$(hostname)" \
    "${HOME}/.config/zsh/local-completions" \
    "${HOME}/.config/zsh/zsh-completions/src" \
    $fpath \
)
# shellcheck source=zsh/.zshcomplete
source ~/.zshcomplete
# }}}
# zsh configuration {{{
# shellcheck source=zsh/.zshinput
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
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
# shellcheck disable=SC2154
export SPROMPT="Correct ${fg[red]}%R$reset_color to ${fg[green]}%r$reset_color? [ynae] "
export KEYTIMEOUT=5
# plugins {{{
# zsh-syntax-highlighting {{{
# shellcheck disable=SC2154,SC2034
{
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# shellcheck source=zsh/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# shellcheck disable=SC1094
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
}
# }}}
# zsh-autosuggestions {{{
# shellcheck source=zsh/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# shellcheck disable=SC1094
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# shellcheck disable=SC2034
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
# see https://github.com/zsh-users/zsh-autosuggestions/issues/619
unset ZSH_AUTOSUGGEST_USE_ASYNC
# }}}
# }}}
# prompt {{{
if type starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
# }}}
# }}}
# fortune {{{
fortune -n600 -s ~/.local/share/fortune | grep -v -E "^$"
# }}}
# vim: fdm=marker
