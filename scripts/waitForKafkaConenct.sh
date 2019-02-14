#!/bin/bash


export URL="$KAFKA_CONNECT_HOST:28083"



check_status ()
{
	curl $URL/connectors &> /dev/null
	echo $?
}



#while ! ping -c 1 -n -w 1 kafka-connect &> /dev/null
result=$(check_status)
while [ ! $result == 0 ]
do
	sleep 1
    echo "Trying to connect to kafka-connect"
	result=$(check_status)
done
printf "\n%s\n"  "Kafka-Connect is online"

