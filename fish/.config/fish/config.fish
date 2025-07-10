for file in ~/.config/sh/rc.d/*
    source "$file"
end

function fish_greeting
    fortune -n600 -s ~/.local/share/fortune | grep -v -E "^\$"
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
    bind -M insert up history-prefix-search-backward
    bind -M insert down history-prefix-search-forward

    if [ -n "$TMUX" ] && type page-up-within-tmux >/dev/null 2>&1
        bind pageup page-up-within-tmux
        bind -M insert pageup page-up-within-tmux
    end

    if [ -n "$ZELLIJ" ] && type page-up-within-zellij >/dev/null 2>&1
        bind pageup page-up-within-zellij
        bind -M insert pageup page-up-within-zellij
    end

    if type atuin >/dev/null 2>&1 && type _atuin_search >/dev/null 2>&1
        bind ctrl-r _atuin_search
        bind -M insert ctrl-r _atuin_search
    end

    fish_config theme choose 'Tomorrow Night Bright'
    set fish_color_valid_path 7fd3ed
    set fish_color_search_match --background=222
end
