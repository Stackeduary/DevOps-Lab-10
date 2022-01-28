# Flask imports
from flask import Flask, render_template, send_file, make_response, url_for, Response
from controller import *

# create Flask app
app = Flask(__name__)

# main route
@app.route('/')

def home():
    get_influxdata()
    return render_template('index.html', name='IoT data')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
