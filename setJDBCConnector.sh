#!/bin/bash

# This script configures a JDBC Source Connector to a MYSQL Database in the
# My-TRAC Platform. 
 
function print_usage {
  echo " Usage: setJDBCConnector.sh <Options>"
	echo " Options: "
  echo " -k|--kafka-connect <kafka connect host> (required)"
  echo " -m|--mysql <mysql host> (required)"
  echo " -d|--database <the database to connecto to> (required)"
  echo " -u|--user <the user> (required)"
  echo " -p|--password <the password> (required)"
  echo " -c|--connector-name <the name of the connector> (required)"
  echo " -i|--incrementing-column <the incrementing column primary key> (required)"
  echo " -t|--timestamp-column <the timestamp column> (required)"
  echo " -n|--names <comma separated list with the topic names to source> (required)"
  echo " -f|--prefix <the prefix to prepend to the toic name> (Default:\"\")"
}

KAFKA_CONNECT_HOST_=
MYSQL_HOST_=
DATABASE_=
USER_=
PASSWORD_=
CONNECTOR_NAME_=
INCREMENTING_NAME_=
TIMESTAMP_NAME_=
TOPIC_NAMES_=
TOPIC_PREFIX_=""
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
		-i|--incrementing-column)
			INCREMENTING_COLUMN_="$2"
			shift # past argument
			;;
		-t|--timestamp-column)
			TIMESTAMP_COLUMN_="$2"
			shift # past argument
			;;
		-n|--names)
			TOPIC_NAMES_="$2"
			shift # past argument
			;;
<<<<<<< HEAD
		-f|--prefix)
			TOPIC_PREFIX_="$2"
			shift # past argument
			;;
=======
>>>>>>> d8ac77704d540b5365911c704855598bdf195c54
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

if [[ -z $INCREMENTING_COLUMN_ ]]; then
  echo "--incrementing-column not set"
  print_usage
  exit 1
fi

if [[ -z $TIMESTAMP_COLUMN_ ]]; then
  echo "--timestamp-column not set"
  print_usage
  exit 1
fi

if [[ -z $TOPIC_NAMES_ ]]; then
  echo "--names not set"
  print_usage
  exit 1
fi

echo ""
echo "Adding JDBC SOURCE connector with options:"
echo "kafka-connect = $KAFKA_CONNECT_HOST_"
echo "mysql = $MYSQL_HOST_"
echo "database = $DATABASE_"
echo "user = $USER_"
echo "password = $PASSWORD_"
echo "connector-name = $CONNECTOR_NAME_"
echo "incrementing-column = $INCREMENTING_COLUMN_"
echo "timestamp-column = $TIMESTAMP_COLUMN_"
echo "names = $TOPIC_NAMES_"
echo ""
echo ""

CONNECTOR="{ 
\"name\": \"$CONNECTOR_NAME_\", 
\"config\": { 
\"connector.class\": \"io.confluent.connect.jdbc.JdbcSourceConnector\", 
\"tasks.max\": 1,
\"connection.url\":\"jdbc:mysql://$MYSQL_HOST_/$DATABASE_?user=$USER_&password=$PASSWORD_\", 
\"mode\": \"timestamp+incrementing\", 
\"incrementing.column.name\": \"$INCREMENTING_COLUMN_\", 
\"timestamp.column.name\": \"$TIMESTAMP_COLUMN_\", 
\"topic.prefix\": \"$TOPIC_PREFIX_\",
\"poll.interval.ms\": 1000,
\"table.whitelist\":\"$TOPIC_NAMES_\",
\"transforms\":\"createKey,extractLong\",
\"transforms.createKey.type\":\"org.apache.kafka.connect.transforms.ValueToKey\",
\"transforms.createKey.fields\":\"$INCREMENTING_COLUMN_\",
\"transforms.extractLong.type\":\"org.apache.kafka.connect.transforms.ExtractField"'$Key'"\",
\"transforms.extractLong.field\":\"$INCREMENTING_COLUMN_\"}
}"

echo $CONNECTOR | curl -X POST \
  -H "Content-Type: application/json" \
  --data @- \
  $KAFKA_CONNECT_HOST_/connectors

echo ""
echo ""
exit 0
