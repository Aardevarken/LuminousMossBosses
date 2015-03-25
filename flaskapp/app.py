from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify 
from werkzeug.utils import secure_filename
import json, sha, os, datetime, importlib
from sqlalchemy import and_
from dbhandler.database import db_session, db_update
from dbhandler.models import Observation, DetectionObject, Device, User 
from util.filename import *
from util.miscellaneous import * 

# configuration
DEBUG = True# Change this to false when put into production 
SECRET_KEY = '90b70bfa992696d63140ca63fcb035cf'
USERNAME = 'admin'
PASSWORD = '19b95897c63fcc7b81d90396ce28bf94dedc67e9'

UPLOAD_FOLDER ='/work/pics/pending/all' 
THUMBNAIL_FOLDER = '/work/pics/thumbnails'
ALLOWED_EXTENSIONS = set(['jpg', 'jpeg'])
ALLOWED_DEVICES = set(['iOS','AndroidPhone', 'AndroidDevice'])
MAX_LIST_ITEMS = 15

# initiate application
app = Flask(__name__)
app.config.from_object(__name__)
app.config.from_envvar('FLASK_APP_SETTINGS', silent=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

#def connect_db():
@app.teardown_appcontext
def shutdown_session(exception=None):
    db_session.remove()

@app.route('/')
def home_page():
    return render_template('index.html', title = 'Home')

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != app.config['USERNAME']:
            error = 'Invalid username'
        elif sha.new(request.form['password']).hexdigest() != app.config['PASSWORD']:
            error = 'Invalid password'
        else:
            session['logged_in'] = True
            return redirect(url_for('observation_list'))
    return render_template('login.html', error=error)

@app.route('/signup', methods=['POST'])
def signup():
    error = None
    username = raw_input(request.form['susername']).lower()
    password = request.form['spassword']
    confirm_password = request.form['sconfirm_password']
    first = request.form['sfirst']
    last = request.form['slast']
    email = request.form['semail']
    if not checkValuesExist(username, password, first, last, email):
        error = 'Empty Required Field'
    elif password != confirm_password:
        error = 'Invalid password'
    else:
        user = User(username, password, first, last, email) 
        db_session().add(user)
        db_session().commit()
    return render_template('login.html', error=error)

    
@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('login'))

def generate_filtered_list(ufilter, query, model, attribute):
    url_filter = request.args.get(ufilter);
    page = request.args.get('page')
    page = 0 if page is None else int(page)

    maxpage = int(query.count()/MAX_LIST_ITEMS)

    items = query
    if (url_filter == "null"):
        items = items.filter(getattr(model, attribute)==None)
    elif (url_filter is not None):
        items = items.filter(getattr(model, attribute)==url_filter)
    items = items.offset(page*MAX_LIST_ITEMS).limit(MAX_LIST_ITEMS).all()

    url_filter = "" if url_filter is None else "&"+ufilter+"="+url_filter
    return (items, {'page':page,'maxpage':maxpage,ufilter:url_filter})

@app.route('/observation_list')
def observation_list():
    if not session.get('logged_in'):
        return redirect(url_for('login'))

    query = db_session().query(Observation.ObsID, Observation.Date, Observation.IsSilene, Observation.FileName, Device.DeviceId, Device.DeviceType).outerjoin(Device, Observation.Device_id==Device.id)
    
    result = generate_filtered_list('verified', query, Observation, 'IsSilene')
    return render_template('observation_list.html', observations=result[0], urlargs=result[1])

@app.route('/device_list')
def device_list():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    
    query = db_session().query(Device.id, Device.DeviceId, Device.DeviceType, Device.IsBlackListed, User.Username).outerjoin(User, Device.UserId == User.UserId)
    
    result = generate_filtered_list('bl', query, Device, 'IsBlackListed')
    return render_template('device_list.html', devices=result[0], urlargs=result[1])

@app.route('/user_list')
def user_list():
    if not session.get('logged_in'):
        return redirect(url_for('login'))

    query = db_session().query(User)
    result = generate_filtered_list('utyp', query, User, 'Type')
    return render_template('user_list.html', users=result[0], urlargs=result[1])

@app.route('/observation_view')
def observation_view():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    page = request.args.get('imageid', 0, type=int)
    observation = db_session().query(Observation.ObsID, Observation.Date, Observation.Longitude, Observation.Latitude, Observation.IsSilene, Observation.FileName)
    obsId = db_session().query(Observation.ObsID)

    page = page if page is not None else 1

    prepage = getSQLNoneValue(obsId.order_by(Observation.ObsID.desc()).filter(Observation.ObsID < page).first())
    nextpage = getSQLNoneValue(obsId.order_by(Observation.ObsID.asc()).filter(Observation.ObsID > page).first())

    observation = observation.filter(Observation.ObsID == page).first()
    urlargs = {'page':page,'prepage':prepage,'nextpage':nextpage}
    return render_template('image_viewer.html', observation=observation, urlargs=urlargs)

@app.route('/_get_observation_data')
def get_observation_data():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    page = request.args.get('imageid', 0, type=int)
    observation = db_session().query(Observation.FileName).filter(Observation.ObsID == page).first()
    observation_object = db_session().query(DetectionObject.XCord, DetectionObject.YCord, DetectionObject.Radius, DetectionObject.IsUserDetected).filter(DetectionObject.ParentObsID == page).all()
    circles = []
    for obj in observation_object:
        circles.append({'XCord':obj.XCord,'YCord':obj.YCord,'Radius':obj.Radius,'IsUserDetected':obj.IsUserDetected})
    return jsonify(FileName=observation.FileName, circles=circles) 

def update_isValue(module, attribute):
    data = {'error':None, 'results':None}
    try:
        value = request.form.get('sentValue', type=int)
        value = bool(value) if value != -1 else None
        value_id = request.form.get('sentId', type=int)
        setattr(db_session().query(module).get(value_id), attribute, value)
        data['results'] = "Updated values"
    except Exception,e:
        data['error'] = str(e)
        data['results'] = "Failed to update values"
    db_session().commit()
    return data

@app.route('/_update_isSilene', methods=["POST"])
def update_isSilene():
    if not session.get('logged_in'):
        return "I can't let you do that Dave" 
    
    return jsonify(data=update_isValue(Observation, 'IsSilene'))

@app.route('/_update_isBlackListed', methods=["POST"])
def update_isBlackListed():
    if not session.get('logged_in'):
        return "I can't let you do that Dave" 
    
    return jsonify(data=update_isValue(Device, 'IsBlackListed'))

@app.route('/_post_observation', methods=["POST"])
def post_observation():
    try:
        # Get Data
        Obs = request.form
        Time = str(Obs['Time'])#datetime.datetime.now().time()
        Time = Time if Time is not None else datetime.datetime.now().time()
        Date = str(Obs['Date'])#datetime.datetime.now().date()
        Date = Date if Date is not None else datetime.datetime.now().date()
        Latitude = float(Obs['Latitude'])
        Longitude = float(Obs['Longitude'])
        DeviceId = str(Obs['DeviceId'])
        DeviceType = str(Obs['DeviceType'])

        if not checkValuesExist(Latitude, Longitude, DeviceId, DeviceType):
            raise ValueError('Values cannot be null')

        if DeviceType not in ALLOWED_DEVICES:
            raise ValueError('Device not allowed')

        # Check if phone is in the database
        device = db_session.query(Device.id).filter(and_( \
            Device.DeviceId == DeviceId, \
            Device.DeviceType == DeviceType)).first()

        if device is None:
            device = Device(DeviceId, DeviceType)
            db_session().add(device)
            db_session().commit()

        # Get File
        newFile = request.files['picture']
        if newFile and allowed_file(newFile.filename):
            filename = secure_filename(newFile.filename)
            while getSQLNoneValue(db_session().query(Observation.FileName) \
                    .filter(Observation.FileName == filename).first()) is not None:
                filename = createUniqueFileName(filename, DeviceType)
            print filename
            newFile.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        
        os.system("convert -thumbnail 150 " + os.path.join(app.config['UPLOAD_FOLDER'], filename) \
                + " " + os.path.join(THUMBNAIL_FOLDER, filename))

        observation = Observation(Time, Date, Latitude, Longitude, filename, UPLOAD_FOLDER, device.id) 
        db_session().add(observation)
        db_session().commit()
        results = "sent"
        errors = None

    except Exception,e:
        results = "failed"
        errors = e.message + " " + repr(e)

    return jsonify(results=results, errors=errors)

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5003)
