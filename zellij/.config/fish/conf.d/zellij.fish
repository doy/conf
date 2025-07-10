function zellij_tab_name_update --on-event fish_prompt --on-event fish_preexec --on-event fish_postexec
    if [ -n "$ZELLIJ" ]
        if [ -n "$argv" ]
            set prefix "$(string replace -r ' .*' '' $argv) - "
        else
            set prefix ""
        end
        set root "$(git root || pwd)"
        zellij action rename-tab "$prefix$(string replace $HOME '~' $root)"
        zellij action rename-pane "$prefix$(string replace $HOME '~' $root)"
    end
end

function page-up-within-zellij
    zellij action switch-mode scroll
    zellij action page-scroll-up
end
