#!/bin/bash


export URL="$KAFKA_CONNECT_HOST:28083"
export MYSQL="$MYSQL_HOST"

echo ""
echo "Delete connector to $URL/connectors"

echo ""
echo ""

if [ ! -z "$1" ]
then
    echo "Overwritting CONNECTOR_NAME to $1"
    CONNECTOR_NAME=$1
fi

curl -X DELETE $URL/connectors/$CONNECTOR_NAME

echo ""
echo ""
