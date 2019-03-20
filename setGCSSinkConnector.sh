#!/bin/bash


#git clone https://github.com/My-TRAC/ConfigurationScripts.git
#./ConfigurationScripts/waitForKafkaConenct.sh


echo $CONNECT_BOOTSTRAP_SERVERS
echo $TOPICS
echo $KAFKA_CONNECT_HOST


curl -X POST -H "Content-Type: application/json" --data "{ \"name\": \"gcs\", \"config\": { \"connector.class\": \"io.confluent.connect.gcs.GcsSinkConnector\", \"tasks.max\": \"1\", \"topics\": \"$TOPICS\", \"gcs.bucket.name\": \"my-trac_storage\", \"gcs.part.size\": \"5242880\", \"flush.size\": \"3\", \"gcs.credentials.path\": \"/opt/cigo-core/credentials/My-TRAC-9b31e91cc907.json\", \"storage.class\": \"io.confluent.connect.gcs.storage.GcsStorage\", \"format.class\": \"io.confluent.connect.gcs.format.avro.AvroFormat\", \"partitioner.class\": \"io.confluent.connect.storage.partitioner.DefaultPartitioner\", \"schema.compatibility\": \"NONE\", \"confluent.topic.bootstrap.servers\": \"$CONNECT_BOOTSTRAP_SERVERS\", \"confluent.topic.replication.factor\": \"1\", \"name\": \"gcs\" }}" $KAFKA_CONNECT_HOST:28083/connectors
