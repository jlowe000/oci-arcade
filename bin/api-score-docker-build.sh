docker images
docker rmi api-score
BUILD_OPTIONS=""
if [ "$1" != "" ]
then
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg ORDS_HOSTNAME=$1"
fi 
if [ "$2" != "" ]
then
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg API_PASSWORD=$2"
fi 
if [ ! -f infra/compute/key.pem ]; then
    OPENSSL_PWD=""
    if [ "$2" != "" ]
	then 
	  OPENSSL_PWD="-passin pass:$2"
	fi
    openssl req -x509 -newkey rsa:4096 ${OPENSSL_PWD} -subj /CN=AU/ -keyout infra/compute/key.pem -out infra/compute/cert.pem -days 365
fi
docker build ${BUILD_OPTIONS} --tag api-score --file containers/web/api-score.Dockerfile .
