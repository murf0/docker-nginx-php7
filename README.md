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
Empty container with no configuration done. Edit the files in your docker container volume to setup for use with php and nginx. php7-fpm is listening at the socket /var/run/php7-fpm.sock

PHP7-FPM and NGINX starts via runit scripts

#Build process
```
git clone https://github.com/murf0/docker-nginx-php7.git
docker build -t nginx-php7:latest docker-nginx-php7
docker run -v /data:/data -P nginx-php7:latest --name php7test
```

This will pull the latest php7 nightly and install in a new docker image

#Sample nginx config
Add this in your  server { } block
```
# pass the PHP scripts to FastCGI server listening on /var/run/php7-fpm.sock
    #
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php7-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
        fastcgi_index index.php;
        include fastcgi_params;
    }   
```

#Extra optional git clone
For each of the environment variables specified below a git clone will be performed. This is done every start of the container, So be careful.
_WARNING_ if these variables are set at restart of the container or host all files local to the container will be removed.

see script gitclone.sh for more info.

##Environment
```
ETC=<git repo uri for /data/etc/>
WWW=<git repo uri for /data/www/>
```
###Login

If login is needed set it using this
```
ETC=https://username:password@github.com/username/repository.git
```

#Maintainer
Mikael Mellgren <mikael@murf.se> gpg:37F17EEC