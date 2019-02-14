#!/bin/bash


#export URL="kafka-connect-avor:28083"
export URL="$KAFKA_CONNECT_HOST:28083"
export MYSQL="$MYSQL_HOST"


echo ""
echo "Adding JDBC SOURCE connector to $URL/connectors"

echo ""
echo ""

CONNECTOR="{ 
\"name\": \"$JDBC_SOURCE_CONNECTOR_NAME\", 
\"config\": { 
\"connector.class\": \"io.confluent.connect.jdbc.JdbcSourceConnector\", 
\"tasks.max\": 1,
\"connection.url\": \"jdbc:mysql://$MYSQL_HOST:3306/connect_test?user=root&password=confluent\", 
\"mode\": \"incrementing\", 
\"incrementing.column.name\": \"id\", 
\"timestamp.column.name\": \"modified\", 
\"topic.prefix\": \"CigoJdbc\", 
\"poll.interval.ms\": 1000,
\"table.blacklist\":\"ratings\" } 
}"



echo $CONNECTOR | curl -X POST \
  -H "Content-Type: application/json" \
  --data @- \
  $URL/connectors

  echo ""
  echo ""
