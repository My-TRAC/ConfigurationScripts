# Author: Arnau Prat (arnau@sparsity.technologies.com)
#
# Describes the latest version of the specified schema
# 

DEFAULT_SCHEMA_REGISTRY_HOSTNAME=$(docker-machine ip cigo):8081
SCHEMA_REGISTRY_HOSTNAME=${2:-$DEFAULT_SCHEMA_REGISTRY_HOSTNAME}

if [[ ! -z $1 ]]
then
  echo "Describing schema $1 from $SCHEMA_REGISTRY_HOSTNAME"
  curl -X GET http://${SCHEMA_REGISTRY_HOSTNAME}/subjects/$1/versions/latest
  echo ""
fi

exit 0
