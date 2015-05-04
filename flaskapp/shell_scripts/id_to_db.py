import sys, os
import subprocess
from sqlalchemy import select, text
from dbhandler.database import db_session
from dbhandler.models import Observation, DetectionObject

FINDFLOWER_LOCATION = '/home/ubuntu/LuminousMossBosses/AlgTester/findflowers'
BOW_PROBABILITY_LOCATION = '/home/ubuntu/LuminousMossBosses/AlgTester/bow_probability'

POS_DETECT_TRUE = 1
USER_DETECT_FALSE = 0

obs_id = sys.argv[1]
obs = db_session().query(Observation).filter(Observation.ObsID == obs_id).first()

picture_location = obs.Location + '/' + obs.FileName
print FINDFLOWER_LOCATION + ' ' + picture_location + ' 2> /dev/null'
p = subprocess.Popen(FINDFLOWER_LOCATION + ' ' + picture_location + ' 2> /dev/null', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
lines = p.stdout.readlines()
p.wait()

numflowers = 0

for line in lines:
        x,y,r = line.rstrip().split(" ")
	numflowers += 1
        # only want to add to the db if there is not already an identical detection object
        if not db_session.query(DetectionObject).filter(DetectionObject.ParentObsID == obs_id, DetectionObject.XCord == x, DetectionObject.YCord == y, DetectionObject.Radius == r, DetectionObject.IsUserDetected == USER_DETECT_FALSE).first():
            flower = DetectionObject(x, y, r, POS_DETECT_TRUE, USER_DETECT_FALSE, obs_id)
            db_session().add(flower)
            print "new: ",x,y,r
        else:
            print "old: ",x,y,r

p = subprocess.Popen(BOW_PROBABILITY_LOCATION + ' ' + picture_location + ' 2> /dev/null', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
line = p.stdout.readline()

p.wait()

bow_probability = float(line)
bow_detected = bow_probability >= 0.45625
obs.Probability = bow_probability
obs.IDbyAlgorithm = bow_detected or (numflowers > 0)
print bow_probability
db_session().commit()
