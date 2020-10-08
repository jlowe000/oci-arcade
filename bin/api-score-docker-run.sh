docker run -d --rm -p 8081:8081 --name api-score --hostname api-score api-score
docker network connect arcade_network api-score

