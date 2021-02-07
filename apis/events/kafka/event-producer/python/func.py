import io
import json
import logging
import sys
import os
# import traceback

from fdk import response
from kafka import KafkaProducer

BOOTSTRAP_SERVER = os.environ.get('BOOTSTRAP_SERVER')
OSS_USER = os.environ.get('API_USER')
OSS_PASSWORD = os.environ.get('API_PASSWORD')
TOPIC = os.environ.get('TOPIC')

def handler(ctx, data: io.BytesIO = None):
    try:
        body = json.loads(data.getvalue())
        if OSS_USER != None or OSS_USER != "":
            producer = KafkaProducer(bootstrap_servers=[BOOTSTRAP_SERVER],
                security_protocol = 'SASL_SSL',
                sasl_mechanism = 'PLAIN',
                sasl_plain_username = OSS_USER,
                sasl_plain_password = OSS_PASSWORD,
                key_serializer=lambda x: json.dumps(x).encode('utf-8'),
                value_serializer=lambda x: json.dumps(x).encode('utf-8'))
        else:
            producer = KafkaProducer(bootstrap_servers=[BOOTSTRAP_SERVER],
                security_protocol = 'PLAINTEXT',
                key_serializer=lambda x: json.dumps(x).encode('utf-8'),
                value_serializer=lambda x: json.dumps(x).encode('utf-8'))
        producer.send(TOPIC, key=body['instance_id'], value=body)
        producer.flush()
        producer.close()
        return response.Response(ctx, response_data=json.dumps({"message": "good"}), headers={"Content-Type": "application/json"})
    except (Exception, ValueError) as ex:
        return response.Response(ctx, response_data=json.dumps({"message": str(ex)}), headers={"Content-Type": "application/json"})

