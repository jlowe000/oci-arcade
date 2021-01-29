export FN_API_URL=http://localhost:8082
echo "paste docker network connect arcade_network fnserver"
fn start --env-file containers/fn/fnserver.conf -p 8082 --log-level DEBUG
