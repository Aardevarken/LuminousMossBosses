#!/usr/bin/python
import sys, os
import subprocess
from sqlalchemy import select, text

from dbhelper import query_database

for path in sys.argv[1:]:
  abspath = os.path.abspath(path)
  location = os.path.dirname(abspath)
  filename = os.path.basename(abspath)

  # Add to images table.
  query = text("INSERT INTO images SET Location = \'" + location + "\', FileName = \'" + filename + "\';")
  query_database(query)

  # Get auto assigned image id
  query = text("SELECT ImageID FROM images WHERE Location = \'" + location + "\' AND FileName = \'" + filename + "\';")
  for row in query_database(query):
    imageid = row['ImageID']
  print imageid 

  # Add observation.
  query = text("INSERT INTO observations SET ImageID = \'" + str(imageid) + "\', Date = CURDATE(), Time = CURTIME(), Latitude = RAND(), Longitude = RAND();")
  query_database(query)

  # Add flower objects.
  p = subprocess.Popen('./findflowers ' + abspath + ' 2> /dev/null', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  lines = p.stdout.readlines()
  p.wait()

  for line in lines:
    x, y, r = line.rstrip().split(" ")
    query = text("INSERT INTO detection_objects SET ParentImageID = \'" + str(imageid) + "\', XCord = \'" + str(x) + "\', YCord = \'" + str(y) + "\', Radius = \'" + str(r) + "\', IsUserDetected = 0;")
    query_database(query)
  
