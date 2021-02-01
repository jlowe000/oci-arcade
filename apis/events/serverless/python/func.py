import io
import json
import logging
import requests
from requests.auth import HTTPBasicAuth

from fdk import response

def handler(ctx, data: io.BytesIO = None):
    try:
        ORDS_HOSTNAME = ctx.Config()['ORDS_HOSTNAME']
        APEX_WORKSPACE = ctx.Config()['APEX_WORKSPACE']
        API_USER = ctx.Config()['API_USER']
        API_PASSWORD = ctx.Config()['API_PASSWORD']
        body = json.loads(data.getvalue())
        res = requests.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/oauth/token', data={'grant_type':'client_credentials'}, auth=HTTPBasicAuth(API_USER, API_PASSWORD));
        access_token = res.json()['access_token'];
        res = requests.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/event_table/', body, headers={ 'Authorization': 'Bearer '+access_token});
        return response.Response(ctx, response_data=res.json(),headers={"Content-Type": "application/json"})
    except (Exception, ValueError) as ex:
        logging.getLogger().info('error parsing json payload: ' + str(ex))
        return response.Response(ctx, str(ex))

    logging.getLogger().info("Inside Python Hello World function")
