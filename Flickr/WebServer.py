import os
from flask import Flask, request, redirect, url_for
from werkzeug import secure_filename
import pickle
import PIL
import pika
import hashlib

hostname= '127.0.0.1' #os.environ['RABBIT_HOST'] \
          #if 'RABBIT_HOST' in os.environ else 'rabbitmq-server.local'
connection = pika.BlockingConnection(pika.ConnectionParameters(host=hostname))
channel = connection.channel()


app = Flask(__name__)

UPLOAD_FOLDER = '/tmp'
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/scan", methods=['POST', 'GET'])
def scan():
    if request.method == 'POST':
        file = request.files['file']
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            sFileName =  os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save( sFileName )
            print "File is ", sFileName
            fd = open(sFileName, 'rb')
            fileContents = fd.read()
            #
            # Prepare a tuple of the file name and file contents
            #
            digest = hashlib.md5(fileContents).hexdigest()
            tup = (sFileName, digest, fileContents)
            pickled = pickle.dumps(tup)
            #
            # You can print it out, but it is very long
            #
            print "pickled item is ", len(pickled),"bytes"
            #
            # Send the picture to the scanners
            #
            channel.exchange_declare(exchange='scanners',type='fanout')
            channel.basic_publish(exchange='scanners',
                                  routing_key='',
                                  body=pickled)
            print " [x] Sent photo ", sFileName
            os.remove(sFileName)
            return '{"digest":"%s"}' % (digest)
        else:
            abort(403)

if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0', port=80)
