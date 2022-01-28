import pandas as pd
from influxdb import InfluxDBClient
import sys
import os

dbname = sys.argv[1]

client = InfluxDBClient(host=os.getenv("INFLUX_DB_HOST"), port=8086)

# check for existing databases
client.drop_database(dbname)
client.create_database(dbname)
client.switch_database(dbname)

filename = sys.argv[2]
file_path = open(filename, 'r')
csvReader = pd.read_csv(file_path)

for row_index, row in csvReader.iterrows():
    tags = row[3]
    json_body = [{
        "measurement": row[0], 
        "time": row[2], 
        "tags": {
            "host": tags
        },
        "fields": {
            "unit": row[4],
            "value": row[5],
        }
        }]
    print(json_body)
    client.write_points(json_body)
