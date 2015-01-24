from flask import Flask, url_for, request
from sqlalchemy import create_engine, select, text
from json import dumps

app = Flask(__name__)

HOST = 'localhost'
USER = 'web_test'
PASSWORD = 'sileneidene'
DATABASE = 'gpstest'

"""
Takes a query, which should be a sqlalchemy.sql.expression.text
object if input was gathered from a POST, and a string otherwise.
Returns the result of the query as a sqlalchemy ResultProxy object
"""
def query_database(query):
    gps_eng = create_engine('mysql://%s:%s@%s/%s' % (USER, PASSWORD, HOST, DATABASE), echo=True)
    gps_conn = gps_eng.connect()
    query_result = gps_conn.execute(query)
    return query_result 

"""
Takes a query result as a sqlalchemy ResultProxy object.
Returns a JSON-formatted string of the passed query result
"""
def result_to_json(query_result):
    column_names = query_result.keys()
    row_list = []
    for row in query_result:
        i = 0
        row_dict = {}
        for item in row:
            row_dict[str(column_names[i])] = str(item)
            i += 1
        row_list.append(row_dict)
    #replace single quote with double for valid json
    json_result = str(row_list).replace('\'', '"')
    return json_result

"""
GET /test_records

returns all records with model_number='test'
"""
@app.route('/test_records', methods=['GET'])
def api_test_records():
    result = query_database('SELECT * FROM test_data WHERE model_number = \'test\'')
    #be aware that this call will close the result object, and it will not be useable afterward.
    items = result_to_json(result)
    return items 

"""
POST /get_test_with_model/
model=MODEL_NUMBER

returns records with model_number matching request in JSON format
"""
@app.route('/get_test_with_model/', methods=['POST'])
def getTestWithModel():
    model=request.form['model']
    #this syntax is neccessary to sanitize the input.
    query = text("SELECT * FROM test_data WHERE model_number = :model_number").bindparams(model_number=model)
    result = query_database(query)
    items = result_to_json(result)
    return items

"""
PUT /add_test/
model=MODEL_NUMBER&gps_accuracy=TEST_GPS_ACCURACY&time_search=TIME_SPENT_SEARCHING_FOR_SIGNAL&time_recorded=TIME_TEST_PERFORMED

Returns response indicating whether or not the row was successfully
inserted into the database.
"""
@app.route('/add_test/', methods=['PUT'])
def addTest():
    data = request.get_json()
    print data.keys()
    if 'model' in data.keys():
        print "true"
    return "hello\n"
    

if __name__ == '__main__':
    app.run(host='0.0.0.0')
