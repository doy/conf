#!/bin/sh

start-pulseaudio-x11

# these have to all happen before xcape is started
setxkbmap -option ctrl:nocaps
setxkbmap -option compose:caps
xmodmap $HOME/.Xmodmap
$HOME/.bin/numkeys on

xinput set-prop "TPPS/2 IBM TrackPoint" "Device Enabled" 0
synclient TapButton1=1
synclient TapButton2=2
synclient TapButton3=3

pidof svscan || (svscan $HOME/.services 2>&1 | readproctitle $USER ........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................) &

exec i3
