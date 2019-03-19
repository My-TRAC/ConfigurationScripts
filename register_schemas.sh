#/bin/sh

# Author: Arnau Prat (arnau@sparsity.technologies.com)
#
# This script downloads a data-model repository and initializes the schema
# registry with the avro schemas found in the repo. The repository must follow
# the following structure:
#     - /
#        |-avro
#           |- schema1.avro
#           |- schema2.avro
#           |- ...
#           |- scheman.avro
# 
# For each schema found, a schema-registry subject will be created, named as the
# schema file, without the avro extension (e.g. for the file schema1.avro, the
# subject name will be "schema1")
#
# Variables:
# 
#   - DATA_MODEL_REPOSITORY (Required): The git repository with the data-model from
#   - SCHEMA_REGISTRY_HOST_NAME (Required): The the host name the schema
#   registry. 
#   - SCHEMA_REGISTRY_PORT (Required): The the port of the schema registry 

if [ -z ${DATA_MODEL_REPOSITORY} ]
then
  echo "DATA_MODEL_REPOSITORY variable not set"
  exit 1
fi

if [ -z ${SCHEMA_REGISTRY_HOST_NAME} ]
then
  echo "SCHEMA_REGISTRY_HOST_NAME variable not set"
  exit 1
fi

if [ -z ${SCHEMA_REGISTRY_PORT} ]
then
  echo "SCHEMA_REGISTRY_PORT variable not set"
  exit 1
fi

git clone $DATA_MODEL_REPOSITORY data

### Registers each schema found in $FOLDER
echo "Registering schemas found in $FOLDER into ${SCHEMA_REGISTRY_HOST_NAME}:${SCHEMA_REGISTRY_PORT}"
for file in data/avro/*.avsc
do
  BASE_NAME=$(basename $file .avsc)
  echo "Registering schema $BASE_NAME"
  until curl -X POST -H "Content-Type: application/json" \
  --data "@$file" \
  http://${SCHEMA_REGISTRY_HOST_NAME}:${SCHEMA_REGISTRY_PORT}/subjects/$BASE_NAME/versions
  do
    sleep 5
  done
done

echo ""
exit 0
