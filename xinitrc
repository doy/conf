#!/bin/bash

. /home/doy/.bashrc
conky &
xscreensaver -no-splash &
watch_lock &
#exec startfluxbox
urxvtd -q -o -f
exec xmonad
