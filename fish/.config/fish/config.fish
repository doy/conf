for file in ~/.config/sh/rc.d/*
    source "$file"
end

function fish_greeting
    fortune -n600 -s ~/.local/share/fortune | grep -v -E "^\$"
end

function page-up-within-tmux
    if [ -n "$TMUX" ]
        tmux copy-mode -u
    else if [ -n "$ZELLIJ" ]
        zellij action switch-mode scroll
        zellij action page-scroll-up
    end
end

if status is-interactive
    fish_vi_key_bindings

    bind ')' beginning-of-line
    bind gg beginning-of-buffer
    bind ge end-of-buffer
    bind gh beginning-of-line
    bind gs beginning-of-line
    bind gl end-of-line
    bind mm jump-to-matching-bracket

    bind pageup page-up-within-tmux
    bind -M insert pageup page-up-within-tmux

    source ~/.config/sh/fzf/shell/key-bindings.fish
    fzf_key_bindings
    bind ctrl-r fzf-history-widget
    bind -M insert ctrl-r fzf-history-widget

    if type starship >/dev/null 2>&1
        starship init fish | source
    end
end
