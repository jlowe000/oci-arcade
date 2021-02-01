LINE=`cat infra/db/client.csv`
API_USER=`echo $LINE | cut -f 1 -d ,`
API_PASSWORD=`echo $LINE | cut -f 2 -d ,`
cd apis/events/serverless/python
cp func.yaml.template func.yaml
echo "config:" >> func.yaml
echo "  ORDS_HOSTNAME: $1" >> func.yaml
echo "  APEX_WORKSPACE: ociarcade" >> func.yaml
echo "  API_USER: $API_USER" >> func.yaml
echo "  API_PASSWORD: $API_PASSWORD" >> func.yaml
fn deploy --app events --local
cd -
