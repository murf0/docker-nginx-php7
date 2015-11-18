#!/bin/sh
set -e
if [ ! "x${ETC}" = "x" ]; then
    cd /data/etc
    rm -rf *
    git clone ${ETC}
    echo "Cloned etc config"
fi

if [ ! "x${WWW}" = "x" ]; then
    cd /data/www
    rm -rf *
    git clone ${WWW}
    echo "Cloned www config"
fi