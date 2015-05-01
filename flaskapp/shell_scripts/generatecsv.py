"""generatecsv.py
This script queries the database for the field specified in the sql query
and outputs this query in comma separated value (csv) format to a file named
observationsYYYYmmddHHMMSS.csv
where 
Y: year
m: month
d: day
H: hour
M: minute
S: second
For the date and time the file was created. The current order of columns is:
ObsId (Observation ID)
Latitude
Longitude
LocationError (Location Accuracy)
Date
Probability (Bag of Words Probability)
NumFlowers (Number of Flowers) - # of detection_objects associated with ObsId
"""



from sqlalchemy import create_engine
import time

HOST = 'localhost'
USER = 'flaskapi'
PASSWORD = 'totallynotapassword'
DATABASE = 'luminous_db'

engine = create_engine('mysql://%s:%s@%s/%s' % (USER, PASSWORD, HOST, DATABASE), echo=False)

conn = engine.connect()
query_result = engine.execute('select ObsID, Latitude, Longitude, LocationError, Date, Probability, count(ObjectID) as NumFlowers, isSilene, IDbyAlgorithm, DeviceId, DeviceType from observations join devices on devices.id = Device_id and DeviceType in ("iOS", "AndroidPhone", "AndroidDevice") left join detection_objects on ParentObsID = ObsID group by ObsID;')
with open('observations' + time.strftime("%Y%m%d%H%M%S") + ".csv", 'w') as csv_file:
    csv_file.write("Observation ID,Latitude,Longitude,Location Accuracy,Date,Bag of Words Probability,Number of Flowers,Researcher Verified,Identified by Algorithm,Device ID,Device Type\n")
    for row in query_result:
        record = ""
        for item in row:
            record += str(item)
            record += ","
        record = record[:-1]
        record += "\n"
        csv_file.write(record)
