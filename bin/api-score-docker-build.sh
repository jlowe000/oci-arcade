if [ ! -f infra/compute/key.pem ]; then
    openssl req -x509 -newkey rsa:4096 -keyout infra/compute/key.pem -out infra/copute/cert.pem -days 365
fi
docker images
docker rmi api-score
if [ "$1" != "" ]
then
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg ORDS_HOSTNAME=$1"
fi 
if [ "$2" != "" ]
then
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg API_PASSWORD=$2"
fi 
docker build ${BUILD_OPTIONS} --tag api-score --file containers/web/api-score.Dockerfile .
