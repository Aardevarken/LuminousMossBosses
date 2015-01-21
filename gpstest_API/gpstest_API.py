from flask import Flask, url_for
from sqlalchemy import create_engine, select
from json import dumps

app = Flask(__name__)

HOST = 'localhost'
USER = 'web_test'
PASSWORD = 'sileneidene'
DATABASE = 'gpstest'

def query_database(query):
    gps_eng = create_engine('mysql://%s:%s@%s/%s' % (USER, PASSWORD, HOST, DATABASE), echo=True)
    gps_conn = gps_eng.connect()
    query_result = gps_conn.execute(query)
    return query_result 

@app.route('/')
def api_root():
    return 'Welcome\n'

@app.route('/test_records')
def api_test_records():
#    result = query_database('SELECT * FROM test_data WHERE model_number = \'test\'')
#    eng = create_engine('mysql://%s:%s@%s/%s' % (USER, PASSWORD, HOST, DATABASE), echo = True)
#    conn = eng.connect()
#    result = conn.execute('SELECT * FROM test_data WHERE model_number = \'test\'')
    result = query_database('SELECT * FROM test_data WHERE model_number = \'test\'')
    items = []
    for row in result:
        items.append(row)
        print items
    return str(items)

@app.route('/articles/<articleid>')
def api_article(articleid):
    return 'You are reading ' + articleid + '\n'

if __name__ == '__main__':
    #this is just attempting to establish a connection and get info from the database. Move this into the
    #API calls later.
    app.run(host='0.0.0.0')
