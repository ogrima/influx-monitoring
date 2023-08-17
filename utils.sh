
# Run Grafana
docker run -d --name=grafana  --network monitoring  -p 3000:3000 grafana/grafana

# Generate influxdb config file sample
docker pull influxdb:2.0.7
docker run --rm influxdb:2.0.7 influxd print-config > config.yml

#Run influxdb
docker run --name influxdb -d -p 8086:8086 --network monitoring --volume ./influxdb2:/var/lib/influxdb2 --volume ./config.yml:/etc/influxdb2/config.yml influxdb:2.7.1

# Run telegraf Agent
 docker run --network monitoring -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro telegraf

 #Run telegraf agent locally
 .\telegraf --config-directory .