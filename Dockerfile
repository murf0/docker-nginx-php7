FROM phusion/baseimage:latest

MAINTAINER Mikael@murf.se

ENV HOME /root

RUN apt-get update && apt-get --no-install-recommends -y upgrade
ADD http://repos.zend.com/zend-server/early-access/php7/php-7.0-latest-DEB-x86_64.tar.gz /tmp/php.tar.gz

COPY build.sh /build.sh
RUN chmod 755 /build.sh
RUN /build.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443

VOLUME ["/data"]

CMD ["/sbin/my_init"]