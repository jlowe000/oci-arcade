export FN_API_URL=http://localhost:8082
fn start --env-file containers/fn/fnserver.conf -p 8082 -d
docker network connect arcade_network fnserver
