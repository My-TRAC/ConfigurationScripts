#!/bin/bash
export URL="$KAFKA_CONNECT_HOST:28083"


  
echo ""
echo "Adding Elastic-Search connector to http://$URL/connectors"

echo ""
echo ""

if [ ! -z "$1" ]
then 
    echo "Overwritting ELASTICSEARCH_CONNECTOR_NAME to $1"
    ELASTICSEARCH_CONNECTOR_NAME=$1
fi


curl -X POST   -H "Content-Type: application/json" --data "{\"name\": \"$ELASTICSEARCH_CONNECTOR_NAME\", \"config\": { \"connector.class\": \"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector\", \"tasks.max\": \"1\", \"topics\": \"$ELASTIC_TOPICS\", \"key.ignore\": \"true\", \"schema.ignore\": \"true\", \"connection.url\": \"http://elasticsearch:9200\", \"type.name\": \"test-type\", \"name\": \"elasticsearch-sink\" }}" http://$URL/connectors
\

  echo ""
  echo ""
