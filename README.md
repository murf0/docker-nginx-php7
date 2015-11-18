# nginx PHP7
Based on phusin/baseimage
#Configuration files
All files stored in /data

```
    /data/www
    /data/etc
    /data/logs
```
Symlinks
```
    /var/www -> /data/www
    /etc/nginx -> /data/etc
    /var/log/nginx -> /data/logs
```

#Shortinfo
Empty container with no configuration done. Edit the files in your docker container volume to setup.

PHP7-FPM and NGINX starts via runit scripts

#Maintainer
Mikael Mellgren <mikael@murf.se> gpg:37F17EEC


#Build process
```
git clone https://github.com/murf0/docker-nginx-php7.git
docker build -t nginx-php7:latest docker-nginx-php7
```

This will pull the latest php7 nightly and install in a new docker image
