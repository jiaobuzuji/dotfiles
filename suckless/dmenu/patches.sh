#! /usr/bin/env bash
mkdir -p patches
cd patches

curl -fSLO "https://tools.suckless.org/dmenu/patches/fuzzyhighlight/dmenu-fuzzyhighlight-4.9.diff"
curl -fSLO "https://tools.suckless.org/dmenu/patches/center/dmenu-center-20200111-8cd37e1.diff"
curl -fSLO "https://tools.suckless.org/dmenu/patches/fuzzymatch/dmenu-fuzzymatch-4.9.diff"

cd ..

