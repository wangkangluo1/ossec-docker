#!/bin/bash
set -x
echo "connect to mysql server:  ${MYSQL_SERVER}"
echo "username: ${MYSQL_USERNAME}"
echo "password: ${MYSQL_PASSWORD}"
echo "db: ${MYSQL_DB}"


if [ ! -f /root/initd ]; then
   # update ossec mysql setup
   cd /var/ossec/etc
   sed -ie "s/MYSQL_SERVER/${MYSQL_SERVER}/" ossec.conf
   sed -ie "s/MYSQL_USERNAME/${MYSQL_USERNAME}/" ossec.conf
   sed -ie "s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/" ossec.conf
   sed -ie "s/MYSQL_DB/${MYSQL_DB}/" ossec.conf

   # update analogi mysql
   cd /var/www/html/analogi
   db_user_line="$(grep -nP 'define.*DB_USER_O' db_ossec.php|cut -f1 -d:)"
   db_pwd_line="$(grep -nP 'define.*DB_PASSWORD_O' db_ossec.php|cut -f1 -d:)"
   db_host_line="$(grep -nP 'define.*DB_HOST_O' db_ossec.php|cut -f1 -d:)"
   db_name_line="$(grep -nP 'define.*DB_NAME_O' db_ossec.php|cut -f1 -d:)"
   
   sed -ie "${db_host_line}s/'127.0.0.1'/'${MYSQL_SERVER}'/" db_ossec.php
   sed -ie "${db_user_line}s/'ossecuser'/'${MYSQL_USERNAME}'/" db_ossec.php
   sed -ie "${db_pwd_line}s/'ossec'/'${MYSQL_PASSWORD}'/" db_ossec.php 
   sed -ie "${db_name_line}s/'ossec'/'${MYSQL_DB}'/" db_ossec.php
   /var/ossec/bin/ossec-control enable database
   touch /root/initd
fi

/etc/init.d/apache2 restart
/var/ossec/bin/ossec-control restart

while true; do sleep 1000; done
