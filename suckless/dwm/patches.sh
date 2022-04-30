#! /usr/bin/env bash
mkdir -p patches
cd patches

# patch : alpha fullscreen hide_vacant_tags viewontag
# actualfullscreen fixborders noborderfloatingfix
curl -OfSL https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff
curl -OfSL https://dwm.suckless.org/patches/xfce4-panel/dwm-xfce4-panel-20220306-d39e2f3.diff
curl -OfSL https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-20211013-cb3f58a.diff

cd ..

