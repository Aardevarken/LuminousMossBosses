#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys
from flask import Flask, url_for, request
from sqlalchemy import text

from dbhelper import query_database, result_to_json
import cgihelper


# returns all observations, most recent first
try:
  result = query_database(text('SELECT * FROM images WHERE ImageID=' + arguments["imageid"] + ';'))
except:
  sys.exit("Error occured. Database may be down. Try again later and check your parameters.")
#be aware that this call will close the result object, and it will not be useable afterward.
items = result_to_json(result)
print items
