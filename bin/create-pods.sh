#!/bin/bash

THEHOST=$(hostname)

# create postgres pod

podman pod create --name kogito-pg -p 5432:5432

podman run --name kogito-pg-server \
       --pod kogito-pg \
       -d \
       -e POSTGRES_USER=kogito-user \
       -e POSTGRES_PASSWORD=kogito-pass \
       -e POSTGRES_DB=kogito \
       postgres:13

# create kafka pod

podman pod create --name kogito-kafka -p 9092:9092

podman run --name kogito-zookeeper \
       --pod kogito-kafka \
       -d \
       -e LOG_DIR=/tmp/logs \
       --tmpfs /tmp \
       quay.io/strimzi/kafka:0.25.0-kafka-2.8.0 \
       bin/zookeeper-server-start.sh config/zookeeper.properties

podman run --name kogito-kafka-server \
       --pod kogito-kafka \
       -d \
       -e KAFKA_BROKER_ID=0 \
       -e KAFKA_ZOOKEEPER_CONNECT=localhost:2181 \
       -e KAFKA_LISTENERS=INTERNAL://localhost:29092,EXTERNAL://0.0.0.0:9092 \
       -e KAFKA_ADVERTISED_LISTENERS=INTERNAL://localhost:29092,EXTERNAL://$THEHOST:9092 \
       -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT \
       -e KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL \
       -e KAFKA_AUTO_CREATE_TOPICS_ENABLE="true" \
       -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
       -e LOG_DIR="/tmp/logs" \
       --tmpfs /tmp \
       --requires kogito-zookeeper \
       --entrypoint bash \
       quay.io/strimzi/kafka:0.25.0-kafka-2.8.0 \
       -c "bin/kafka-server-start.sh config/server.properties --override inter.broker.listener.name=\${KAFKA_INTER_BROKER_LISTENER_NAME} --override listener.security.protocol.map=\${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP} --override listeners=\${KAFKA_LISTENERS} --override advertised.listeners=\${KAFKA_ADVERTISED_LISTENERS} --override zookeeper.connect=\${KAFKA_ZOOKEEPER_CONNECT}"

# create dataindex pod
podman pod create --name kogito-data-index-pg -p 8180:8080

podman run --name kogito-data-index-pg-server \
       --pod kogito-data-index-pg \
       -d \
       -e KAFKA_BOOTSTRAP_SERVERS=$THEHOST:9092 \
       -e QUARKUS_DATASOURCE_DB-KIND=postgresql \
       -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://$THEHOST:5432/kogito \
       -e QUARKUS_DATASOURCE_USERNAME=kogito-user \
       -e QUARKUS_DATASOURCE_PASSWORD=kogito-pass \
       -e QUARKUS_HIBERNATE_ORM_DATABASE_GENERATION=update \
       quay.io/kiegroup/kogito-data-index-postgresql:1.12