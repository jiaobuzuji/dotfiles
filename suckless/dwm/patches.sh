#! /usr/bin/env bash
mkdir -p patches
cd patches

curl -OfSL "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff"
curl -fSLO "https://dwm.suckless.org/patches/systray/dwm-systray-6.3.diff"
curl -fSLO "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.3.diff"
curl -fSLO "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff"
curl -fSLO "https://dwm.suckless.org/patches/scratchpad/dwm-scratchpad-6.2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/focusmonmouse/dwm-focusmonmouse-6.2.diff"
curl -fSLO "https://dwm.suckless.org/patches/focusadjacenttag/dwm-focusadjacenttag-6.3.diff"
curl -fSLO "https://dwm.suckless.org/patches/viewontag/dwm-viewontag-20210312-61bb8b2.diff"
curl -fSLO "https://dwm.suckless.org/patches/movestack/dwm-movestack-20211115-a786211.diff"
curl -fSLO "https://dwm.suckless.org/patches/movecenter/dwm-movecenter-6.2.diff"
curl -fSLO "https://dwm.suckless.org/patches/rotatestack/dwm-rotatestack-20161021-ab9571b.diff"

# curl -fSLO "https://dwm.suckless.org/patches/stackmfact/dwm-6.0-smfact.diff"
# curl -fSLO "https://dwm.suckless.org/patches/alpha/dwm-alpha-20201019-61bb8b2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/alpha/dwm-fixborders-6.2.diff"
curl -fSLO "https://dwm.suckless.org/patches/noborder/dwm-noborder-6.2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/focusmaster/"
# curl -fSLO "https://dwm.suckless.org/patches/focusonclick/dwm-focusonclick-20200110-61bb8b2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/fullscreen/dwm-fullscreen-6.2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-20211013-cb3f58a.diff"

cd ..

# curl -fSLO "https://dwm.suckless.org/patches/awesomebar/dwm-awesomebar-20200907-6.2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/gridmode/dwm-gridmode-20170909-ceac8c9.diff"
# curl -OfSL https://dwm.suckless.org/patches/xfce4-panel/dwm-xfce4-panel-20220306-d39e2f3.diff
# curl -fSLO "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/xresources/dwm-xresources-20210827-138b405.diff"
# curl -fSLO "https://dwm.suckless.org/patches/tatami/dwm-tatami-6.2.diff"
# curl -fSLO "https://dwm.suckless.org/patches/dwmc/dwm-dwmc-6.2.diff"

