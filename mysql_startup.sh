#!/bin/bash

PATH="$PATH:/bin"

# Set the server_id if not set
[ -z "$SERVER_ID" ] && SERVER_ID=1

if env | grep -q ^SERVER_ID=
then
    echo env variable is already exported
else
    echo env variable was not exported, but now it is
    export SERVER_ID
fi


if [ ! -f /var/lib/mysql/mysql-bin.index ]; then
    /usr/bin/mysql_install_db
    sleep 10s

    chown -R mysql:mysql /var/lib/mysql

    /usr/sbin/mysqld --user=mysql --max_allowed_packet=250M --server_id=${SERVER_ID} --log_bin=mysql-bin --utility-user='repl@%' --utility-user-privileges='replication slave' --utility_user_password='repl' --relay-log="db${SERVER_ID}" --max_binlog_files=2 &
    sleep 10s

    echo "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'admin'; FLUSH PRIVILEGES" | mysql
    
    if env | grep -q ^SLAVE=
    then
	START_SLAVE="CHANGE MASTER TO MASTER_HOST='${DB_1_PORT_3306_TCP_ADDR}', MASTER_USER='repl', MASTER_PASSWORD='repl', MASTER_PORT=${DB_1_PORT_3306_TCP_PORT}, MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=120, MASTER_CONNECT_RETRY=10; start slave;"
	export START_SLAVE
    
	mysql -uroot -h127.0.0.1 -e "${START_SLAVE}" 
	echo $START_SLAVE

    fi


    
    killall mysqld
    sleep 10s
else
    if env | grep -q ^SLAVE=
    then

	/usr/sbin/mysqld --user=mysql --max_allowed_packet=250M --server_id=${SERVER_ID} --log_bin=mysql-bin --utility-user='repl@%' --utility-user-privileges='replication slave' --utility_user_password='repl'  --skip-slave-start --relay-log-recovery=1 --relay-log="db${SERVER_ID}"  --max_binlog_files=2 &

	START_SLAVE="CHANGE MASTER TO MASTER_HOST='${DB_1_PORT_3306_TCP_ADDR}', MASTER_USER='repl', MASTER_PASSWORD='repl', MASTER_PORT=${DB_1_PORT_3306_TCP_PORT}, MASTER_CONNECT_RETRY=10; start slave;"
	export START_SLAVE
    
	SLAVE_RECOVER="--slave-skip-errors=all --relay-log-recovery=1"
	export SLAVE_RECOVER

	sleep 10s
	mysql -uroot -h127.0.0.1 -e "${START_SLAVE}" 
	echo $START_SLAVE
	sleep 5s
	killall mysqld
	sleep 10s
    fi

fi

#--relay-log="db${SERVER_ID}"

/usr/sbin/mysqld --user=mysql --max_allowed_packet=250M --server_id=${SERVER_ID} --log_bin=mysql-bin --utility-user='repl@%' --utility-user-privileges='replication slave' --utility_user_password='repl' --relay-log="db${SERVER_ID}"  --max_binlog_files=2 ${SLAVE_RECOVER}

