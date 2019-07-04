#!/bin/bash


# This script configures a JDBC Sink Connector to a MYSQL Database in the
# My-TRAC Platform. 
 
function print_usage {
  echo " Usage: setJDBCSinkConnector.sh <Options>"
	echo " Options: "
  echo " -k|--kafka-connect <kafka connect host> (required)"
  echo " -m|--mysql <mysql host> (required)"
  echo " -s|--schema-registry <the schema registry host> (required)"
  echo " -d|--database <the database to connecto to> (required)"
  echo " -u|--user <the user> (required)"
  echo " -p|--password <the password> (required)"
  echo " -c|--connector-name <the name of the connector> (required)"
  echo " -pk|--primary-key <the primary key field name> (required)"
  echo " -n|--names <comma separated list with the topic names to source> (required)"
}

KAFKA_CONNECT_HOST_=
MYSQL_HOST_=
SCHEMA_REGISTRY_HOST_=
DATABASE_=
USER_=
PASSWORD_=
CONNECTOR_NAME_=
PRIMARY_KEY_NAME_=
TOPIC_NAMES_=
HELP_=

# options parsing
while [[ $# > 0 ]]
do
	key="$1"

	case $key in
		-h|--help)
			HELP_=YES
			;;
		-k|--kafka-connect)
			KAFKA_CONNECT_HOST_="$2"
			shift # past argument
			;;
		-m|--mysql)
			MYSQL_HOST_="$2"
			shift # past argument
			;;
		-s|--schema-registry)
			SCHEMA_REGISTRY_HOST_="$2"
			shift # past argument
			;;
		-d|--database)
			DATABASE_="$2"
			shift # past argument
			;;
		-u|--user)
			USER_="$2"
			shift # past argument
			;;
		-p|--password)
			PASSWORD_="$2"
			shift # past argument
			;;
		-c|--connector-name)
			CONNECTOR_NAME_="$2"
			shift # past argument
			;;
		-pk|--primary-key)
			PRIMARY_KEY_NAME_="$2"
			shift # past argument
			;;
		-n|--names)
			TOPIC_NAMES_="$2"
			shift # past argument
			;;
	esac
	shift
done


if [[ ! -z $HELP ]]
then
  print_usage
  exit 1
fi

if [[ -z $KAFKA_CONNECT_HOST_ ]]; then
  echo "--kafka-connect not set"
  print_usage
  exit 1
fi

if [[ -z $MYSQL_HOST_ ]]; then
  echo "--mysql not set"
  print_usage
  exit 1
fi

if [[ -z $SCHEMA_REGISTRY_HOST_ ]]; then
  echo "--schema-registry not set"
  print_usage
  exit 1
fi

if [[ -z $DATABASE_ ]]; then
  echo "--database not set"
  print_usage
  exit 1
fi

if [[ -z $USER_ ]]; then
  echo "--user not set"
  print_usage
  exit 1
fi

if [[ -z $PASSWORD_ ]]; then
  echo "--password not set"
  print_usage
  exit 1
fi

if [[ -z $CONNECTOR_NAME_ ]]; then
  echo "--connector-name not set"
  print_usage
  exit 1
fi

if [[ -z $PRIMARY_KEY_NAME_ ]]; then
  echo "--primary-key not set"
  print_usage
  exit 1
fi

if [[ -z $TOPIC_NAMES_ ]]; then
  echo "--names not set"
  print_usage
  exit 1
fi

echo ""
echo "Adding JDBC SINK connector with options:"
echo "kafka-connect = $KAFKA_CONNECT_HOST_"
echo "mysql = $MYSQL_HOST_"
echo "schema-registry = $SCHEMA_REGISTRY_HOST_"
echo "database = $DATABASE_"
echo "user = $USER_"
echo "password = $PASSWORD_"
echo "connector-name = $CONNECTOR_NAME_"
echo "primary-key = $PRIMARY_KEY_NAME_"
echo "names = $TOPIC_NAMES_"
echo ""
echo ""


CONNECTOR="
{\"name\": \"$CONNECTOR_NAME_\", 
\"config\": {\"connector.class\":\"io.confluent.connect.jdbc.JdbcSinkConnector\", 
\"tasks.max\":\"1\", 
\"topics\":\"$TOPIC_NAMES_\", 
\"connection.url\":\"jdbc:mysql://$MYSQL_HOST_/$DATABASE_?user=$USER_&password=$PASSWORD_\", 
\"key.converter\":\"io.confluent.connect.avro.AvroConverter\", 
\"key.converter.schema.registry.url\":\"http://$SCHEMA_REGISTRY_HOST_\", 
\"value.converter\":\"io.confluent.connect.avro.AvroConverter\", 
\"value.converter.schema.registry.url\":\"http://$SCHEMA_REGISTRY_HOST_\", 
\"insert.mode\":\"upsert\", 
\"batch.size\":\"0\", 
\"auto.create\":\"false\", 
\"pk.mode\":\"record_value\", 
\"pk.fields\":\"$PRIMARY_KEY_NAME_\" }
}
"

echo $CONNECTOR | curl -X POST -H "Content-Type: application/json" \
  --data @- \
  $KAFKA_CONNECT_HOST_/connectors
  echo ""
  echo ""
