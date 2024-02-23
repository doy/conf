#!/bin/sh

# shellcheck source=xorg/.xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

exec i3
