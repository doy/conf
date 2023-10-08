#!/bin/sh

# shellcheck source=xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

exec i3
