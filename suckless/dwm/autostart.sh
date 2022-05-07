#! /usr/bin/env bash

picom -o 0.95 -i 0.88 --detect-rounded-corners --vsync --blur-background-fixed -f -D 5 -c -b
slstatus & # dwmstatus &
fcitx & # ibus &
nm-applet &
xfce4-power-manager &
#xfce4-volumed-pulse &
