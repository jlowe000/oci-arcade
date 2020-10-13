docker images
docker rmi oci-kafka-events
docker build --tag oci-kafka-events --file containers/kafka/oci-kafka-events.Dockerfile .
