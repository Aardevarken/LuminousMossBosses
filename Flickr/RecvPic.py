import sys,os
import pickle
import ScanSilene
import GetLatLon
import tempfile
import PIL
import pika
import MySQLdb
import boto
import logging
logging.basicConfig()

mysqlhostname = "127.0.0.1"
rabbithostname= "127.0.0.1"

db = MySQLdb.connect(host=mysqlhostname, user="root", passwd="", db="silene")
cur = db.cursor()
insert = "INSERT INTO detections SET checksum=%s, latitude=%s, longitude=%s, issilene=%s"
insertnogeo = "INSERT INTO detections SET checksum=%s, issilene=%s"
insertwithimg = "INSERT INTO detections SET checksum=%s, latitude=%s, longitude=%s, issilene=%s, filename=%s"
insertnogeowithimg = "INSERT INTO detections SET checksum=%s, issilene=%s, filename = %s"

s3 = boto.connect_s3()
bucket = s3.get_bucket('dcsc')

def imageType(filename):
    try:
        i=PIL.Image.open(filename)
        return i.format
    except IOError:
        return False

def photoInfo(pickled):
    # You can print it out, but it is very long
    print "pickled item is ", len(pickled),"bytes"
    unpickled = pickle.loads(pickled)
    print "File name was", unpickled[0], "digest is ", unpickled[1]
    photoFile,photoName = tempfile.mkstemp("photo")
    os.write(photoFile, unpickled[2])
    os.close(photoFile)
    imtype = imageType(photoName)
    newPhotoName = photoName + '.' + imtype
    os.rename(photoName, newPhotoName)
    print "Wrote it to ", newPhotoName
    isSilene = ScanSilene.isThisSilene( newPhotoName )
    print "Silene:", isSilene
    latlon = GetLatLon.getLatLon( newPhotoName )
    print "GeoTag:", latlon
    # Send positive images to S3, key is checksum
    if isSilene:
      keyname = 'silene/' + unpickled[1] + '.' + imtype
      key = bucket.new_key(keyname)
      key.set_contents_from_filename(newPhotoName)
      if latlon[0] == None or latlon[1] == None:
        print cur.execute(insertnogeowithimg, [unpickled[1], isSilene, keyname]), "rows affected"
      else:
        print cur.execute(insertwithimg, [unpickled[1], latlon[0], latlon[1], isSilene, keyname]), "rows affected"
    else:
      # Send to mysql
      if latlon[0] == None or latlon[1] == None:
        print cur.execute(insertnogeo, [unpickled[1], isSilene]), "rows affected"
      else:
        print cur.execute(insert, [unpickled[1], latlon[0], latlon[1], isSilene]), "rows affected"
    db.commit()
    os.remove(newPhotoName)

connection = pika.BlockingConnection(pika.ConnectionParameters(
        host=rabbithostname))
channel = connection.channel()

channel.exchange_declare(exchange='scanners',type='fanout')

result = channel.queue_declare(exclusive=True)
queue_name = result.method.queue
channel.queue_bind(exchange='scanners',queue=queue_name)

print ' [*] Waiting for logs. To exit press CTRL+C'

def callback(ch, method, properties, body):
    photoInfo(body)

channel.basic_consume(callback,
                      queue=queue_name,
                      no_ack=True)

channel.start_consuming()
