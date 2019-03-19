# Author: Arnau Prat (arnau@sparsity.technologies.com)
#
# Lists all the available schemas in the schema registry
# 

DEFAULT_SCHEMA_REGISTRY_HOSTNAME=$(docker-machine ip cigo):8081
SCHEMA_REGISTRY_HOSTNAME=${1:-$DEFAULT_SCHEMA_REGISTRY_HOSTNAME}

echo "Retrieving schemas from $SCHEMA_REGISTRY_HOSTNAME"
curl -X GET http://${SCHEMA_REGISTRY_HOSTNAME}/subjects
echo ""

exit 0
