from sqlalchemy import Column, Integer, String, Date, Time, Float, Boolean, ForeignKey
from sqlalchemy.orm import relationship, backref
from datetime import date, time, datetime
from dbhandler.database import Base

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
        IsPosDetect=None, ParentObsID=None, FileName=None, Location=None):
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
    Username = Column(String(16), unique=True)
    IsSilene = Column(Boolean, unique=True)
    UseForTraining = Column(Boolean, unique=True)
    FileName = Column(String(256), unique=True)
    Location = Column(String(256), unique=True)

    def __init__(self, Time=None, Date=None, Latitude=None,
        Longitude=None, Username=None, IsSilene=None, UseForTraining=None, FileName=None, Location=None):
        #self.ObsID = ObsID
        self.Time = Time
        self.Date = Date
        self.Latitude = Latitude
        self.Longitude = Longitude
        self.Username = Username
        self.IsSilene = IsSilene
        self.UseForTraining = UseForTraining
        self.FileName = FileName
        self.Location = Location

    def __repr__(self):
        return '<Observation %r %r %r %r %r %r>' % (self.Time,
            self.Date, self.Latitude, self.Longitude, self.Username, self.FileName)

class User(Base):
    __tablename__ = 'users'
    UserID = Column(Integer, primary_key=True)
    Username = Column(String(16), unique=True)
    FirstName = Column(String(16), unique=True)
    LastName = Column(String(16), unique=True)
    # Passwords need to be stored as SHA-512 salted, not plain text!!
    Password = Column(String(128), unique=True)
    Status = Column(String(16), unique=True)
    Email = Column(String(64), unique=True)

    def __init__(self, UserID=None, Username=None, FirstName=None, LastName=None, Password=None, Status=None, Email = None):
        self.UserID = UserID
        self.Username = Username
        self.FirstName = FirstName
        self.LastName = LastName
        self.Password = Password
        self.Status = Status
        self.Email = Email

    def __repr__(self):
        return '<User %r %r %r %r %r %r %r>' % (self.UserID, self.Username, self.FirstName, self.LastName, self.Password, self.Status, self.Email) 


'''
# Things to Add Later
class TestResult(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)
class Test(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)

class Training(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)

class ValidPlant(Base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)

class XmlData(base):
    __tablename__ = 'observations'
    ObsID = Column(Integer, primary_key=True)
'''
