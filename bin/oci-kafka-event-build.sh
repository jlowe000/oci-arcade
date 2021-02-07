docker images
docker rmi oci-kafka-events
BUILD_OPTIONS=""
if [ "$1" != "" ]; then
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg ORDS_HOSTNAME=$1"
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg BOOTSTRAP_SERVER=$2"
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg TOPIC=$3"
fi 
if [ -f infra/db/client.csv ]; then
  LINE=`cat infra/db/client.csv`
  API_USER=`echo $LINE | cut -f 1 -d ,`
  API_PASSWORD=`echo $LINE | cut -f 2 -d ,`
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg API_USER=$API_USER"
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg API_PASSWORD=$API_PASSWORD"
fi
docker build --tag oci-kafka-events ${BUILD_OPTIONS} --file containers/kafka/oci-kafka-events.Dockerfile .
