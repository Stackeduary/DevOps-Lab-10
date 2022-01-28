docker stop $INFLUXDB_CONTAINER || true
docker rm $INFLUXDB_CONTAINER || true

docker stop $CADVISOR_CONTAINER || true
docker rm $CADVISOR_CONTAINER || true

docker stop $NODE_EXPORTER_CONTAINER || true
docker rm $NODE_EXPORTER_CONTAINER || true

# create volume for InfluxDB
docker volume create $INFLUX_VOL || true

# CADVISOR to monitor the container resource utilization of the front end system
docker run -d --restart always --name $CADVISOR_CONTAINER -p 8081:8080 -v "/:/rootfs:ro" -v "/var/run:/var/run:rw" -v "/sys:/sys:ro" -v "/var/lib/docker/:/var/lib/docker:ro" google/cadvisor:latest

# NODE-EXPORTER container for monitor VM
docker run -d -p 9100:9100 --name $NODE_EXPORTER_CONTAINER prom/node-exporter

# INFLUXDB container
docker run -d -p 8086:8086 --name $BACKEND_CONTAINER -v $INFLUX_VOL:/var/lib/influxdb2 influxdb:1.1.1

pip install -r ./backend/requirements.txt || true

# insert CSV data into influxdb
python3 ./backend/csvToInfluxDB.py $INFLUX_DB_NAME $CSV_FILENAME
