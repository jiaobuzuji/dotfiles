#! /usr/bin/env bash
mkdir -p patches
cd patches

curl -OfSL https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff
curl -OfSL https://dwm.suckless.org/patches/xfce4-panel/dwm-xfce4-panel-20220306-d39e2f3.diff

cd ..

