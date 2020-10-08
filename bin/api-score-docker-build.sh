docker images
docker rmi api-score
docker build --tag api-score --file containers/web/api-score.Dockerfile .
