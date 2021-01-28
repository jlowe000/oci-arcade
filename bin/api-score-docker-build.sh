if [ ! -f infra/compute/key.pem ]; then
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
fi
docker images
docker rmi api-score
docker build --tag api-score --file containers/web/api-score.Dockerfile .
