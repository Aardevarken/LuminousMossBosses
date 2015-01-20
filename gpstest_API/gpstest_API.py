from flask import Flask, url_for
from sqlalchemy import create_engine, select

app = Flask(__name__)

HOST = 'localhost'
USER = 'web_test'
PASSWORD = 'sileneidene'
DATABASE = 'gpstest'


@app.route('/')
def api_root():
    return 'Welcome\n'

@app.route('/test_records')
def api_test_records():
    return 'List of ' + url_for('api_test_records') + '\n'

@app.route('/articles/<articleid>')
def api_article(articleid):
    return 'You are reading ' + articleid + '\n'

if __name__ == '__main__':
    #this is just attempting to establish a connection and get info from the database. Move this into the
    #API calls later.
    gps_eng = create_engine('mysql://%s:%s@%s/%s' % (USER, PASSWORD, HOST, DATABASE), echo=True)
    gps_conn = gps_eng.connect()
    result = gps_conn.execute('SELECT * FROM test_data WHERE model_number = \'test\'')
    for row in result:
        print row

    app.run(host='0.0.0.0')
