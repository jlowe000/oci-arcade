docker images
docker rmi oci-arcade
docker build --tag oci-arcade --file containers/web/oci-arcade.Dockerfile .
