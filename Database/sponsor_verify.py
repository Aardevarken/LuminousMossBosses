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


# Marks an observation as silene or not.
# sponsor_verify.py?issilene=true/false/0/1&obsid=43
try:
  query_database(text('UPDATE observations SET IsSilene=' + arguments["issilene"] + ' WHERE ObsID=' + arguments["obsid"] + ';'))
except:
  sys.exit("Error occured. Database may be down. Try again later and check your parameters.")
