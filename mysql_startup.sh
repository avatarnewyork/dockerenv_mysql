#!/bin/bash

PATH="$PATH:/bin"

if [ ! -f /var/lib/mysql/ibdata1 ]; then
    /usr/bin/mysql_install_db
    sleep 10s

    /usr/bin/mysqld_safe &
    sleep 10s

    echo "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'admin'; FLUSH PRIVILEGES" | mysql

    killall mysqld
    sleep 10s
fi

#/usr/bin/mysqld_safe &
/usr/libexec/mysqld 
