import sys, os
import subprocess
from sqlalchemy import select, text
from dbhandler.database import db_session
from dbhandler.models import Observation, DetectionObject

FINDFLOWER_LOCATION = '../AlgTester/findflowers'
BOW_PROBABILITY_LOCATION = '../AlgTester/bow_probability'

obs_id = sys.argv[1]
obs = db_session().query(Observation.Location, Observation.FileName).filter(Observation.ObsID == obs_id).first()

picture_location = obs.Location + '/' + Observation.FileName

p = subprocess.Popen(FINDFLOWER_LOCATION + picture_location + '2> /dev/null', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
lines = p.stdout.readlines()
p.wait()

for line in lines:
	x, y, r = line.rstrip().split(" ")
	print x, y, r