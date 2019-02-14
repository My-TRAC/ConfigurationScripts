#!/bin/bash

echo "Waiting for Schema-registry"

export URL="$SCHEMA_REGISTRY_HOST_NAME:8081"




until 
curl -X GET http://$URL/subjects
  do
    sleep 5
	echo "...schema registry still loading..."
done






