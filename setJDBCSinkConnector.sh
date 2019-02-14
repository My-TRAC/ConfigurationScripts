#!/bin/bash


#export URL="kafka-connect-avor:28083"
export URL="$KAFKA_CONNECT_HOST:28083"
export MYSQL="$MYSQL_HOST"
export SR="$SCHEMA_REGISTRY_HOST_NAME:8081"



echo ""
echo "Adding JDBC SINK connector to $URL/connectors"

echo ""
echo ""


#if [ ! -z "$1" ]                                                                                                                       
#then
#    echo "Overwritting JDBC_SINK_CONNECTOR_NAME to $1"
#    JDBC_SINK_CONNECTOR_NAME=$1
#fi


CONNECTOR="
{\"name\": \"$1\", 
\"config\": {\"connector.class\":\"io.confluent.connect.jdbc.JdbcSinkConnector\", 
\"tasks.max\":\"1\", 
\"topics\":\"$SINK_TOPICS\", 
\"connection.url\":\"jdbc:mysql://$MYSQL_HOST:3306/connect_test?user=root&password=confluent\", 
\"key.converter\":\"io.confluent.connect.avro.AvroConverter\", 
\"key.converter.schema.registry.url\":\"http://$SR\", 
\"value.converter\":\"io.confluent.connect.avro.AvroConverter\", 
\"value.converter.schema.registry.url\":\"http://$SR\", 
\"insert.mode\":\"insert\", 
\"batch.size\":\"0\", 
\"auto.create\":\"true\", 
\"pk.mode\":\"none\", 
\"pk.fields\":\"none\" }
}
"

echo $CONNECTOR | curl -X POST -H "Content-Type: application/json" \
  --data @- \
  $URL/connectors

  echo ""
  echo ""
