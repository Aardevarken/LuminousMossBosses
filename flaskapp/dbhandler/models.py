from sqlalchemy import Column, Integer, String, Date, Time, Float, Boolean, ForeignKey, Enum
from sqlalchemy.orm import relationship, backref
from datetime import date, time, datetime
from dbhandler.database import Base
from werkzeug.security import generate_password_hash, check_password_hash

class RotationObject(Base):
    __tablename__ = 'rotation_objects'
    id = Column(Integer, primary_key=True)
    ParentDetectionObjectID = Column(Integer, ForeignKey('detection_objects.ObjectID'))
    RotationAngle = Column(Integer, unique=True)
    FileName = Column(String(256), unique=True)
    Location = Column(String(256), unique=True)

    def __init__(self, ParentDetectionObjectID=None, RotationAngle=None, FileName=None, Location=None):
        self.ParentDetectionObjectID = ParentDetectionObjectID
        self.RotationAngle = RotationAngle
        self.FileName = FileName
        self.Location = Location

    def __repr__(self):
        return '<RotationObject %r, %r, %r>' % (self.RotationObject, self.Location, self.FileName)

class DetectionObject(Base):
    __tablename__ = 'detection_objects'
    ObjectID = Column(Integer, primary_key=True)
    ParentObsID = Column(Integer, ForeignKey('observations.ObsID'))
    XCord = Column(Integer, unique=True)
    YCord = Column(Integer, unique=True)
    Radius = Column(Integer, unique=True)
    IsPosDetect = Column(Integer, unique=True)
    IsUserDetected = Column(Integer, unique=True)
    FileName = Column(String(256), unique=True)
    Location = Column(String(256), unique=True)

    def __init__(self, XCord=None, YCord=None, Radius=None,
        IsPosDetect=None, IsUserDetected=None, ParentObsID=None, FileName=None, Location=None):
        self.XCord = XCord
        self.YCord = YCord
        self.Radius = Radius
        self.IsPosDetect = IsPosDetect
        self.IsUserDetected = IsUserDetected
        self.ParentObsID = ParentObsID
        self.FileName = FileName
        self.Location = Location

    def __repr__(self):
        return '<DetectionObject %r %r %r %r>' % (self.XCord, self.YCord, self.Radius,
            self.IsUserDetected)

class Observation(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)
    Time = Column(Time, unique=True)
    Date = Column(Date, unique=True)
    Latitude = Column(Float, unique=True)
    Longitude = Column(Float, unique=True)
    LocationError = Column(Float, unique=True)
    Device_id = Column(Integer, unique=ForeignKey('devices.id'))
    IsSilene = Column(Boolean, unique=True)
    UseForTraining = Column(Boolean, unique=True)
    FileName = Column(String(256), unique=True)
    Location = Column(String(256), unique=True)
    Probability = Column(Float, unique=True) 
    IDbyAlgorithm = Column(Boolean, unique=True)

    def __init__(self, Time=None, Date=None, Latitude=None,
        Longitude=None, LocationError=None, FileName=None, Location=None, Device_id=None, IsSilene=None, UseForTraining=None, Probability=None, IDbyAlgorithm=None):
        #self.ObsID = ObsID
        self.Time = Time
        self.Date = Date
        self.Latitude = Latitude
        self.Longitude = Longitude
        self.LocationError = LocationError
        self.Device_id = Device_id
        self.IsSilene = IsSilene
        self.UseForTraining = UseForTraining
        self.FileName = FileName
        self.Location = Location
        self.Probability = Probability
        self.IDbyAlgorithm = IDbyAlgorithm

    def __repr__(self):
        return '<Observation %r %r %r %r %r %r>' % (self.Time,
            self.Date, self.Latitude, self.Longitude, self.Device_id, self.FileName)

class Device(Base):
    __tablename__ = 'devices'
    id = Column(Integer, primary_key=True)
    DeviceId = Column(String(64), unique=True)
    DeviceType = Column(String(16), unique=True)
    IsBlackListed = Column(Integer, unique=True)
    UserId = Column(Integer, ForeignKey('users.UserId'))
    
    def __init__(self, DeviceId, DeviceType, UserId=None, IsBlackListed=0):
        self.DeviceId = DeviceId
        self.DeviceType = DeviceType
        self.UserId = UserId
        self.IsBlackListed = IsBlackListed

    def __repr__(self):
        return '<Device %r %r>' % (self.DeviceId, self.DeviceType)

class User(Base):
    __tablename__ = 'users'
    UserId = Column(Integer, primary_key=True)
    Username = Column(String(32), unique=True)
    FirstName = Column(String(16), unique=True)
    LastName = Column(String(16), unique=True)
    # Passwords need to be stored as SHA-512 salted, not plain text!!
    Password = Column(String(128), unique=True)
    Email = Column(String(64), unique=True)
    Type = Column(Enum('admin','developer','normal','subadmin'), unique=True)

    def __init__(self, Username, Password, FirstName=None, LastName=None, Email=None, Type='normal'):
        self.Username = Username
        self.set_password(Password)
        
        self.FirstName = FirstName
        self.LastName = LastName
        self.Email = Email
        self.Type = Type

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def set_password(self, password):
        self.Password = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.Password, password)

    def get_id(self):
        try:
            return unicode(self.UserId)
        except NameError:
            return str(self.UserId)
    def __repr__(self):
        return '<User %r %r %r %r %r>' % (self.UserId, self.Username, self.FirstName, self.LastName, self.Type)

class TestResult(Base):
    __tablename__ = 'testresults'
    TestID = Column(Integer, primary_key=True)
    XMLID = Column(Integer, ForeignKey('xmldata.XMLID'))
    ProbCorrectID = Column(Float, unique=True)
    PerFalsePos = Column(Float, unique=True)
    PerFalseNeg = Column(Float, unique=True)
    PerUnknowns = Column(Float, unique=True)
    
    def __init__(self, XMLID=None, ProbCorrectID=None, PerFalsePos=None, PerFalseNeg=None, PerUnknowns=None):
        self.XMLID = XMLID
        self.ProbCorrectID = ProbCorrectID
        self.PerFalsePos = PerFalsePos
        self.PerFalseNeg = PerFalseNeg
        self.PerUnknowns = PerUknowns

    def __repr__(self):
        return '<TestResult %r %r %>' % (self.TestID, self.XMLID, self.ProbCorrectID);

class XMLData(Base):
    __tablename__ = 'xmldata'
    XMLID = Column(Integer, primary_key=True)
    FileName = Column(String(256), unique=True)
    CreationDate = Column(Date, unique=True)
    CreationTime = Column(Time, unique=True)
    TestName = Column(String(20), unique=True)
    AppVersion = Column(String(10), unique=True)

    def __init__(self, FileName, CreationDate, CreationTime, TestName, AppVersion): 
        self.FileName = FileName
        self.CreationDate = CreationDate
        self.CreationTime = CreationTime
        self.TestName = TestName
        self.AppVersion = AppVersion

    def __repr__(self):
        return '<TestResult %r %r %>' % (self.XMLID, self.FileName)
'''
class ValidPlant(Base):
    __tablename__ = 'validplants'
    ScientificName = Column(String(32), primary_key=True)
    PlantName = Column(String(32), unique=True)
    Description = Column(Blob, unique=True)

    def __init__(self, ScientificName, PlantName, Description):
        self.ScientificName = ScientificName
        self.PlantName = PlantName
        self.Description = Description

    def __repr__(self):
        return '<ValidPlant %r %r %r>' % (self.ScientificName, self.PlantName, self.Description)


# Things to Add Later
class Test(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)

class Training(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)
'''
