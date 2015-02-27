from sqlalchemy import create_engine
from json import dumps

HOST = 'localhost'
USER = 'jamie'
PASSWORD = 'luciDMoss'
DATABASE = 'luminous_db'

"""
Takes a query, which should be a sqlalchemy.sql.expression.text
object if input was gathered from a POST, and a string otherwise.
Returns the result of the query as a sqlalchemy ResultProxy object
"""
def query_database(query):
    gps_eng = create_engine('mysql://%s:%s@%s/%s' % (USER, PASSWORD, HOST, DATABASE), echo=False)
    gps_conn = gps_eng.connect()
    query_result = gps_conn.execute(query)
    return query_result
    
    
"""
Takes a query result as a sqlalchemy ResultProxy object.
Returns a JSON-formatted string of the passed query result
"""
def result_to_json(query_result):
    results = []
    for row in query_result:
        results.append(dict(row))
    return dumps(results)

"""
Takes json request data and required parameters.
Return True if only required parameters included, False otherwise.
"""
def input_has_required_parameters(data, required_parameters):
    keys = sorted(data.keys())
    required_parameters.sort()
    if len(keys) != len(required_parameters):
        print len(keys)
        print 'Wrong number of parameters: keys: ' + str(len(keys)) + ', req_params: ' + str(len(required_parameters))
        return False
    elif keys != required_parameters:
        print "keys did not equal req params"
        print 'keys: ' + str(keys)
        print 'required: ' + str(required_parameters)
        return False
    for k in keys:
        if data[k] in (None,""):
            print "parameter '" + str(k) + "' did not contain data"
            return False
    return True
