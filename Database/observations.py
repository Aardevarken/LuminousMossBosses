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

whereStatement = ''
orderStatement = ' ORDER BY Date DESC, Time DESC'
limitStatement = ''

# get observation by imageid
if 'imageid' in arguments:
    whereStatement = ' WHERE images.ImageID = ' + arguments['imageid']
# get observations by a select range
if 'rangeid' in arguments:
    limitStatement = ' limit ' + arguments['rangeid'];
    orderStatement = ' ORDER BY images.ImageID'
# get observation if it has been verified
if 'isplant' in arguments:
    tmp = "IS NULL" if arguments['isplant'].lower() == 'null' else '= ' + arguments['isplant']
    whereStatement = ' WHERE IsSilene ' + tmp
# sql look up
try:
    sqlStatement = text('SELECT ObsID, DATE_FORMAT(Date,"%Y-%m-%d") as Date, TIME_FORMAT(Time, "%T") as Time, Latitude, Longitude, images.ImageID, IsSilene, FileName FROM observations LEFT JOIN images ON observations.ImageID=images.ImageID'+ whereStatement + orderStatement + limitStatement +';')
    result = query_database(sqlStatement)
except:
    sys.exit("Error occured. Database may be down. Try again later and check your parameters.")
#be aware that this call will close the result object, and it will not be useable afterward.
items = result_to_json(result)
print items
