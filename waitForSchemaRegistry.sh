#!/bin/bash

echo "Waiting for Schema-registry"

if [ -z ${SCHEMA_REGISTRY_PORT} ]
then
    SCHEMA_REGISTRY_PORT = 8081
fi

export URL="$SCHEMA_REGISTRY_HOST_NAME:$SCHEMA_REGISTRY_PORT"




until 
curl -X GET http://$URL/subjects
  do
    sleep 5
	echo "...schema registry still loading..."
done






