#/bin/bash

# Author: Arnau Prat (arnau@sparsity.technologies.com)
#
# Applies the configuration of the given data-model config file 
#
#

if [ ! -f $1 ]
then
  echo "Configuration file $1 does not exist"
  exit 1
fi

source $1

NUM_PARTITIONS=$(kafka-topics --describe --zookeeper zookeeper:32181 --topic _schemas | grep PartitionCount | cut -f 2 | cut -d ":" -f 2)

REPLICATION_FACTOR=$(kafka-topics --describe --zookeeper zookeeper:32181 --topic _schemas | grep ReplicationFactor | cut -f 3 | cut -d ":" -f 2)

for topic in $COMPACTED_TOPICS
do
  kafka-topics --create \
    --zookeeper zookeeper:32181 \
    --topic $topic \
    --config  "cleanup.policy=compact" \
    --partitions $NUM_PARTITIONS \
		--replication-factor $REPLICATION_FACTOR
done
