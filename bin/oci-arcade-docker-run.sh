docker run -d --rm -p 8080:8080 --name oci-arcade --hostname oci-arcade oci-arcade
docker network connect arcade_network oci-arcade

