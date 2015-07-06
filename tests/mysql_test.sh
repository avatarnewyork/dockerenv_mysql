#!/bin/bash

sleep 30;

mysql --silent -uadmin --password='admin' --port="$DB_1_PORT_3306_TCP_PORT" --host="$DB_1_PORT_3306_TCP_ADDR" -e 'create database dockerenv_mysql;'

mysql -uadmin --password='admin' --port="$DB_1_PORT_3306_TCP_PORT" --host="$DB_1_PORT_3306_TCP_ADDR" -e 'show databases' |grep 'dockerenv_mysql' |wc -l

