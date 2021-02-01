cd apis/events/serverless/python
cp func.yaml.template func.yaml
echo "config:" >> func.yaml
echo "  ORDS_HOSTNAME: $1" >> func.yaml
echo "  APEX_WORKSPACE: $2" >> func.yaml
echo "  API_USER: $3" >> func.yaml
echo "  API_PASSWORD: $4" >> func.yaml
fn deploy --app events --local
cd -
