#! /usr/bin/env bash
mkdir -p patches
cd patches

curl -OfSL https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff
curl -OfSL https://st.suckless.org/patches/scrollback/st-scrollback-20210507-4536f46.diff
curl -OfSL https://st.suckless.org/patches/hidecursor/st-hidecursor-0.8.3.diff
curl -OfSL https://st.suckless.org/patches/dracula/st-dracula-0.8.5.diff

cd ..

