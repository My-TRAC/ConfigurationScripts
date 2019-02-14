#!/bin/bash


export URL="$KAFKA_CONNECT_HOST:28083"
export MYSQL="$MYSQL_HOST"

echo ""
echo "Delete connector to $URL/connectors"

echo ""
echo ""

curl -X DELETE $URL/connectors/$CONNECTOR_NAME

echo ""
echo ""
