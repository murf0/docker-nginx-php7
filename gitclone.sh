#!/bin/sh
set -ex
#check if the ETC variable has been set and if it has clean out all the old configuration saved.
# Then clone the repository specified to nginx configuration.
if [ ! "x${ETC}" = "x" ]; then
    rm -rf /data/etc/
    mkdir /data/etc/
    git -c http.sslVerify=false clone ${ETC} /data/etc/
    echo "Cloned etc config"
    if [ -f /data/etc/posthook.sh ]; then
        sh /data/etc/posthook.sh
    fi
fi
#Clone the www-data to datafolder. to use this you need to have your configuration fixed.
if [ ! "x${WWW}" = "x" ]; then
    rm -rf /data/www/
    mkdir /data/www/
    git -c http.sslVerify=false clone ${WWW} /data/www/
    chown -R www-data:www-data /data/www/
    echo "Cloned www config"
fi
