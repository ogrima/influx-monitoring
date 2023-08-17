#!/bin/bash
# create config file
docker run --rm influxdb:2.0.7 influxd print-config > config.yml
# create the container
docker run --name influxdb -d \
  -p 8086:8086 \
  --volume `pwd`/influxdb2:/var/lib/influxdb2 \
  --volume `pwd`/config.yml:/etc/influxdb2/config.yml \
  influxdb:2.0.7
# wait until the database server is ready
until docker exec influxdb influx ping
do
  echo "Retrying..."
  sleep 5
done
# configure influxdb
docker exec influxdb influx setup \
  --bucket $INFLUXDB_BUCKET \
  --org $INFLUXDB_ORG \
  --password $INFLUXDB_PASSWORD \
  --username $INFLUXDB_USERNAME \
  --force
# get the token
docker exec influxdb influx auth list | \
awk -v username=$INFLUXDB_USERNAME '$5 ~ username {print $4 " "}'