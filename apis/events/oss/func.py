import io
import json
import logging
import sys
# import traceback

from fdk import response
from kafka import KafkaProducer

BOOTSTRAP_SERVER = os.environ.get('BOOTSTRAP_SERVER')
OSS_USER = os.environ.get('OSS_USER')
OSS_PASSWORD = os.environ.get('OSS_PASSWORD')

def handler(ctx, data: io.BytesIO = None):
    try:
        body = json.loads(data.getvalue())
        producer = KafkaProducer(bootstrap_servers=[BOOTSTRAP_SERVER],
           security_protocol = 'SASL_SSL', 
           sasl_mechanism = 'PLAIN',
           sasl_plain_username = OSS_USER,
           sasl_plain_password = OSS_PASSWORD,
           value_serializer=lambda x: dumps(x).encode('utf-8'))
        producer.send('project_pac-man_demo_stream', key=key.encode('utf-8'), value=body)
        producer.flush()
        producer.close()
        return response.Response(ctx, response_data=json.dumps({"message": "good"}), headers={"Content-Type": "application/json"})
    except (Exception, ValueError) as ex:
        return response.Response(ctx, response_data=json.dumps({"message": str(ex)}), headers={"Content-Type": "application/json"})

