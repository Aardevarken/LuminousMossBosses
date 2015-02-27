#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys
from flask import Flask, url_for, request
from sqlalchemy import text

import cgi
arguments = dict()
args = cgi.FieldStorage()
#for key in args.keys():
#    arguments[key] = args[key].value

from dbhelper import query_database, result_to_json
import cgihelper
from upload import save_upload

#try:
#print cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
filepath = save_upload('inputfile', args)
print filepath
#except:
#  print "Error uploading image file."
