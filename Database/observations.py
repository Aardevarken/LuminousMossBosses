#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys
from flask import Flask, url_for, request
from sqlalchemy import text

import cgi
arguments = dict()
args = cgi.FieldStorage()
for key in args.keys():
  arguments[key] = args[key].value

from dbhelper import query_database, result_to_json
import cgihelper


# returns all observations, most recent first
if 'imageid' in arguments:
  try:
    result = query_database(text('SELECT ObsID, DATE_FORMAT(Date,"%Y-%m-%d") as Date, TIME_FORMAT(Time, "%T") as Time, Latitude, Longitude, images.ImageID, IsSilene, FileName FROM observations LEFT JOIN images ON observations.ImageID=images.ImageID WHERE images.ImageID = ' + arguments['imageid'] + ' ORDER BY Date DESC, Time DESC;'))
  except:
    sys.exit("Error occured. Database may be down. Try again later and check your parameters.")
  items = result_to_json(result)
  print items
else:
  try:
    result = query_database(text('SELECT ObsID, DATE_FORMAT(Date,"%Y-%m-%d") as Date, TIME_FORMAT(Time, "%T") as Time, Latitude, Longitude, images.ImageID, IsSilene, FileName FROM observations LEFT JOIN images ON observations.ImageID=images.ImageID ORDER BY Date DESC, Time DESC;'))
  except:
    sys.exit("Error occured. Database may be down. Try again later and check your parameters.")
  #be aware that this call will close the result object, and it will not be useable afterward.
  items = result_to_json(result)
  print items
