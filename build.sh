# Set correct environment variables.
set -ex

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
export TERM=dumb


PHP7DEPS="build-essential
libcurl4-openssl-dev \
libmcrypt-dev \
libxml2-dev \
libjpeg-dev \
libfreetype6-dev \
libmysqlclient-dev \
libt1-dev \
libgmp-dev \
libpspell-dev \
libicu-dev \
librecode-dev \
libxpm4 \
libjpeg62"

NGINX="nginx"

EXTRA="git jq"

#To install latest version of nginx
echo "deb http://nginx.org/packages/mainline/debian/ trusty nginx
deb-src http://nginx.org/packages/mainline/debian/ trusty nginx" > /etc/apt/sources.list.d/nginx.list
curl -s -o nginx_signing.key http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
rm nginx_signing.key
apt-get update

apt-get install --no-install-recommends -y $PHP7DEPS $NGINX $EXTRA

cd /
tar -xzPf /tmp/php.tar.gz

cp  /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's#group = nobody#group = www-data#g'  /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's#user = nobody#user = www-data#g'  /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's#;listen.owner = nobody#listen.owner = www-data#g'  /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's#;listen.group = nogroup#listen.group = www-data#g'  /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's#;listen.mode = 0660#listen.mode = 0750#g'  /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's#listen = 127.0.0.1:9000#listen = /var/run/php7-fpm.sock#g'  /usr/local/php7/etc/php-fpm.d/www.conf

cp /usr/local/php7/etc/php-fpm.conf.default /etc/php-fpm.conf
sed -i 's#;pid = run/php-fpm.pid#pid = /var/run/php-fpm.pid#g' /etc/php-fpm.conf
sed -i 's#;daemonize = yes#daemonize = no#g' /etc/php-fpm.conf

curl -s https://raw.githubusercontent.com/ryantenney/php7/master/php.ini-production -o /usr/local/php7/lib/php.ini
echo "zend_extension=opcache.so" >> /usr/local/php7/lib/php.ini


echo "daemon off;
$(cat /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf


#move Nginx folders to /data
mkdir /data /data/www
ln -s /data/www /var/www

mv /var/log/nginx /data/logs
ln -s /data/logs/ /var/log/nginx

mv /etc/nginx /data/etc
ln -s /data/etc/ /etc/nginx


#Add runit configuration
mkdir -p /etc/service/php/ /etc/service/nginx/
#php-fpm
echo "#!/bin/sh
/usr/local/php7/sbin/php-fpm --fpm-config /etc/php-fpm.conf
" > /etc/service/php/run

echo "#!/bin/sh
sv start php || exit 1
/usr/sbin/nginx
" > /etc/service/nginx/run

chmod 755 /etc/service/php/run /etc/service/nginx/run

apt-get -y autoremove
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

rm -- "$0"