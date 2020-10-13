package com.oracle.oci.arcade.events;

import java.io.StringWriter;
import java.io.PrintWriter;
import java.util.Properties;
import org.apache.kafka.clients.producer.*;

public class EventHandler {

    private Properties props;
    private Producer<String, String> producer;

    private void init() {
        if (producer == null) {
            props = new Properties();
            props.put("bootstrap.servers", "kafka_kafka_1:9092");
            props.put("acks", "all");
            props.put("retries", 0);
            props.put("batch.size", 16384);
            props.put("linger.ms", 1);
            props.put("buffer.memory", 33554432);
            props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
            props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
            producer = new KafkaProducer<>(props);
        }
    }

    public String handleRequest(String input) {
        try {
            init();
            System.out.println("input:"+input);
            producer.send(new ProducerRecord<String, String>("oci-arcade-events", input));
        } catch (Exception ex) {
            try { producer.close(); } catch (Exception iex) {}
            producer = null;
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            ex.printStackTrace(pw);
            return "{ 'response' : 'bad', 'exception' : '"+sw.toString()+"' }";
        }
        return "{ 'response' : 'good' }";
    }

}
