#!/bin/bash
cd $KAFKA_HOME
bin/zookeeper-server-start.sh config/zookeeper.properties > /dev/null &

bin/kafka-server-start.sh config/server.properties > /dev/null &

