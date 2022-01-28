FROM python:3.8-slim-buster

WORKDIR /app

ENV INFLUX_DB_NAME=Bill_InfluxDB

ENV INFLUX_DB_HOST=172.17.90.60

COPY ./frontend/requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY ./frontend/ .

CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]
