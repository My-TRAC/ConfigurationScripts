#!/bin/bash

echo "Trying to connect to MySQL"
while ! mysqladmin ping -h"$MYSQL_HOST" -p"$MYSQL_PASSWORD" --silent; do
	echo "Trying to connect to MySQL"
    sleep 1
done
