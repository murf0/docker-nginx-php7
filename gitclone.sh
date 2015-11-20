#!/bin/sh
set -ex
if [ ! "x${ETC}" = "x" ]; then
    rm -rf /data/etc/
    mkdir /data/etc/
    git -c http.sslVerify=false clone ${ETC} /data/etc/
    echo "Cloned etc config"
    if [ -f /data/etc/posthook.sh ]; then
        sh /data/etc/posthook.sh
    fi
fi

if [ ! "x${WWW}" = "x" ]; then
    rm -rf /data/www/
    mkdir /data/www/
    git -c http.sslVerify=false clone ${WWW} /data/www/
    chown -R www-data:www-data /data/www/
    echo "Cloned www config"
fi
