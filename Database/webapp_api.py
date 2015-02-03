#!/usr/bin/python
from flask import Flask, url_for, request
from sqlalchemy import text

from dbhelper import query_database, result_to_json

app = Flask(__name__)
app.config['DEBUG'] = True

@app.route('/observation_list.html', methods=['GET'])
def list_observations():
    return open('../HTML5/observation_list.html').read()

@app.route('/observer.html', methods=['GET'])
def observation():
    return open('../HTML5/observer.html').read()

@app.route('/css/<filename>', methods=['GET'])
def css(filename):
    return open('../HTML5/css/' + filename).read()

@app.route('/js/<filename>', methods=['GET'])
def js(filename):
    return open('../HTML5/js/' + filename).read()

@app.route('/images/<filename>', methods=['GET'])
def images(filename):
    return open('/work/pics/pending/silene/' + filename).read()

"""
GET /observations

returns all observations, most recent first
"""
@app.route('/observations', methods=['GET'])
def get_observations():
    try:
        result = query_database(text('SELECT ObsID, images.ImageID, FileName FROM observations LEFT JOIN images ON observations.ImageID=images.ImageID ORDER BY Date DESC, Time DESC;'))
    except:
        return "Error occured. Database may be down. Try again later and check your parameters.\n"
    #be aware that this call will close the result object, and it will not be useable afterward.
    items = result_to_json(result)
    return items 

@app.route('/imagedata/<imageid>', methods=['GET'])
def get_imagedata(imageid):
    try:
        result = query_database(text('SELECT * FROM images WHERE ImageID=' + str(imageid) + ';'))
    except:
        return "error"
    items = result_to_json(result)
    return items

@app.route('/flowerdetections/<imageid>', methods=['GET'])
def get_flowerdetections(imageid):
    try:
        result = query_database(text('SELECT * from detection_objects WHERE ParentImageID=' + str(imageid) + ';'))
    except:
        return "Error occured. Database may be down. Try again later and check your parameters.\n"
    #be aware that this call will close the result object, and it will not be useable afterward.
    items = result_to_json(result)
    return items 

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)


