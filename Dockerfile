FROM ubuntu:14.04
MAINTAINER roy.wang wangkangluo1@gmail.com

COPY  ./ossec-ubuntu-bin.tar.gz /tmp/ossec-ubuntu-bin.tar.gz

RUN set -xe \ 
    && apt-get update \
    && apt-get install -y wget libmysqlclient-dev mysql-client apache2 php5 libapache2-mod-php5 php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl \
    && tar xvzf /tmp/ossec-ubuntu-bin.tar.gz -C /var \
    #add users, and group
    && useradd ossec \
    && useradd ossecm \
    && useradd ossecr \
    && usermod -G ossec ossec \
    && usermod -G ossec ossecr \
    && usermod -G ossec ossecm 

#ossec web ui
COPY ./v0.8.tar.gz /tmp/v0.8.tar.gz 
RUN cd /tmp \
    && tar -xvzf v0.8.tar.gz \
    && mkdir -p /var/www/html/ossec/tmp/ \
    && mv ossec-wui-0.8/* /var/www/html/ossec/ \
    && chown www-data:www-data /var/www/html/ossec/tmp/ \
    && chmod 666 /var/www/html/ossec/tmp \
    && usermod -a -G ossec www-data 

#install analogi web dashboard
COPY ./analogi.tar.gz /tmp/analogi.tar.gz
RUN tar xvzf /tmp/analogi.tar.gz -C /var/www/html/ \
    && cd /var/www/html/ \
    && cp /var/www/html/analogi/db_ossec.php.new /var/www/html/analogi/db_ossec.php

COPY ./startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

expose 80/tcp
expose 1514/udp

CMD ["/root/startup.sh"]

