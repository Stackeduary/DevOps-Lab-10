docker stop $PROMO_CONTAINER || true
docker rm $PROMO_CONTAINER || true

docker stop $CADVISOR_CONTAINER || true
docker rm $CADVISOR_CONTAINER || true

docker stop $NODE_EXPORTER_CONTAINER || true
docker rm $NODE_EXPORTER_CONTAINER || true

# docker stop $GRAFANA_CONTAINER || true
# docker rm $GRAFANA_CONTAINER || true

# CADVISOR container for monitor VM
docker run -d --restart always --name $CADVISOR_CONTAINER -p 8081:8080 -v "/:/rootfs:ro" -v "/var/run:/var/run:rw" -v "/sys:/sys:ro" -v "/var/lib/docker/:/var/lib/docker:ro" google/cadvisor:latest

# NODE-EXPORTER container for monitor VM
docker run -d -p 9100:9100 --name $NODE_EXPORTER_CONTAINER prom/node-exporter

# Grafana for visualization of resources used by containers and VMs
# docker run -d -p 3000:3000 --name $GRAFANA_CONTAINER grafana/grafana:6.5.0

# PROMETHEUS for collecting metrics using NODE-EXPORTER and CADVISOR
# docker run -d -p 9090:9090 -v $PWD/monitor/prometheus.yml:/etc/prometheus/prometheus.yml --name $PROMO_CONTAINER prom/prometheus --config.file=/etc/prometheus/prometheus.yml

# ALERTMANAGER for sending alert notifications to Slack when Flask service is down
docker run -d -p 9093:9093 -v $PWD/monitor/alertmanager.yml:/alertmanager.yml --name $ALERT_CONTAINER prom/alertmanager --config.file=/alertmanager.yml --cluster.advertise-address=172.17.90.50:9093

docker run -d -p 9090:9090 -v $PWD/monitor/rules.yml:/etc/prometheus/rules.yml -v $PWD/monitor/prometheus.yml:/etc/prometheus/prometheus.yml --name $PROMO_CONTAINER prom/prometheus --config.file=/etc/prometheus/prometheus.yml
