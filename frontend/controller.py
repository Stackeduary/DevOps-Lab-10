import pandas as pd
import os
import datetime
from influxdb import InfluxDBClient
from influxdb.exceptions import InfluxDBClientError, InfluxDBServerError
from requests.exceptions import RequestException
import numpy

# get the current working directory
cwd = os.getcwd()

# get the data from influxdb
def get_influxdata():
    dbname = os.getenv('INFLUX_DB_NAME')
    host = os.getenv('INFLUX_DB_HOST')
    client = InfluxDBClient(host=host, port=8086)
    
    # check for data present in influxdb; else no data are present
    try:
        client.switch_database(dbname)
        query = "select * from CO2;"
        df = pd.DataFrame(client.query(query).get_points())
        index = open(cwd + '/templates/index.html', "a")
        index.write("<br>")
        index.write(df.to_html())
        index.close()
        
    except (RequestException, InfluxDBClientError, InfluxDBServerError) as ex:
        index = open(cwd + '/templates/index.html', "a")
        index.write("<br>")
        index.write("<br>")
        index.write("An exception occurred while retrieving the data from indfluxdb: ", str(ex))
        index.write("Data from " + dbname + " influxdb database cannot be displayed.")
        index.close()
        return "Success"
