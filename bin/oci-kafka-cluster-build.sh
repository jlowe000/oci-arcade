# docker-compose -f containers/kafka/oci-kafka-compose.yml build
docker build -t kafka_kafka -f containers/kafka/oci-kafka-cluster.Dockerfile
