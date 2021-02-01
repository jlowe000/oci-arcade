docker images
docker rmi api-score
BUILD_OPTIONS=""
if [ "$1" != "" ]; then
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg ORDS_HOSTNAME=$1"
fi 
if [ -f infra/db/client.csv ]; then
  LINE=`cat infra/db/client.csv`
  API_USER=`echo $LINE | cut -f 1 -d ,`
  API_PASSWORD=`echo $LINE | cut -f 2 -d ,`
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg API_USER=$API_USER"
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg API_PASSWORD=$API_PASSWORD"
fi
if [ ! -f infra/compute/key.pem ]; then
  OPENSSL_PWD=""
  if [ "$2" != "" ]
  then 
    OPENSSL_PWD="-passout pass:$2"
  fi
  openssl req -x509 -newkey rsa:4096 ${OPENSSL_PWD} -subj /CN=AU/ -keyout infra/compute/key.pem -out infra/compute/cert.pem -days 365
fi
if [ "$2" != "" ]
then 
  BUILD_OPTIONS="${BUILD_OPTIONS} --build-arg CERT_PASSWORD=$2"
fi
docker build --tag api-score ${BUILD_OPTIONS} --file containers/web/api-score.Dockerfile .
