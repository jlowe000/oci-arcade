import sys
import os
import requests
from requests.auth import HTTPBasicAuth
from pykafka import KafkaClient
from pykafka.common import OffsetType
import json

ORDS_HOSTNAME = os.environ.get('ORDS_HOSTNAME')
APEX_WORKSPACE = os.environ.get('APEX_WORKSPACE')
API_USER = os.environ.get('API_USER')
API_PASSWORD = os.environ.get('API_PASSWORD')
BOOTSTRAP_SERVER = os.environ.get('BOOTSTRAP_SERVER')
TOPIC = os.environ.get('TOPIC')

client = KafkaClient(hosts='kafka_kafka_1:9092')
print(client.topics)
topic = client.topics[b'oci-arcade-events']

consumer = topic.get_simple_consumer(auto_offset_reset=OffsetType.LATEST,reset_offset_on_start=True)
for msg in consumer:
  if msg is not None:
    try:
      print(msg.value)
      payload = json.loads(msg.value)
      res = requests.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/oauth/token', data={'grant_type':'client_credentials'}, auth=HTTPBasicAuth(API_USER, API_PASSWORD));
      access_token = res.json()['access_token'];
      res = requests.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/event_table/', payload, headers={ 'Authorization': 'Bearer '+access_token});
      print(res)
    except:
      print('err:',sys.exc_info()[0]);

print('done');
