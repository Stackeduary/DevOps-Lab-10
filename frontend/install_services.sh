docker stop $FLASK_CONTAINER || true
docker rm $FLASK_CONTAINER || true

docker stop $CADVISOR_CONTAINER || true
docker rm $CADVISOR_CONTAINER || true

docker stop $NODE_EXPORTER_CONTAINER || true
docker rm $NODE_EXPORTER_CONTAINER || true

# CADVISOR container for monitor VM
docker run -d --restart always --name $CADVISOR_CONTAINER -p 8081:8080 -v "/:/rootfs:ro" -v "/var/run:/var/run:rw" -v "/sys:/sys:ro" -v "/var/lib/docker/:/var/lib/docker:ro" google/cadvisor:latest

# NODE-EXPORTER container for monitor VM
docker run -d -p 9100:9100 --name $NODE_EXPORTER_CONTAINER prom/node-exporter

echo $TESTNAME
# build Flask application container image
docker build -t $TEST_NAME -f ./frontend/Dockerfile .

# run the Flask application container
docker run -d -p 8082:5000 --name $FLASK_CONTAINER $TEST_NAME
