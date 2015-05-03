from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify, send_file 
from flask.ext.login import LoginManager, login_required, login_user, logout_user 
from flask_user import current_user
from werkzeug.utils import secure_filename
import json, sha, os, datetime, importlib
from sqlalchemy import and_
from dbhandler.database import db_session, engine
from dbhandler.models import Observation, DetectionObject, Device, User, RotationObject 
from util.filename import *
from util.miscellaneous import * 
import subprocess
from shell_scripts.generatecsv import generateCSV
from celery import Celery
from flask_mail import Message, Mail
from util.do_not_add_to_git import Onion
import random, string

#CELERY
def make_celery(app):
    celery = Celery(app.import_name, broker=app.config['CELERY_BROKER_URL'])
    celery.conf.update(app.config)
    TaskBase = celery.Task
    class ContextTask(TaskBase):
        abstract = True
        def __call__(self, *args, **kwargs):
            with app.app_context():
                return TaskBase.__call__(self, *args, **kwargs)
    celery.Task = ContextTask
    return celery

# configuration
DEBUG = True# Change this to false when put into production 
SECRET_KEY = '90b70bfa992696d63140ca63fcb035cf'

CROPPED_FOLDER = '/work/pics/cropped'
ROTATED_FOLDER = '/work/pics/rotated'
UPLOAD_FOLDER ='/work/pics/pending/all' 
THUMBNAIL_FOLDER = '/work/pics/thumbnails'
ALLOWED_EXTENSIONS = set(['jpg', 'jpeg'])
ALLOWED_DEVICES = set(['iOS','AndroidPhone', 'AndroidDevice'])
MAX_LIST_ITEMS = 15

# initiate login manager
login_manager = LoginManager()

# initiate application
app = Flask(__name__)
app.config.update(
        CELERY_BROKER_URL='redis://localhost:5000/0',
        CELERY_RESULT_BACKEND='redis://localhost:5000/0'
)
celery = make_celery(app)
app.config.from_object(__name__)
app.config.from_envvar('FLASK_APP_SETTINGS', silent=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = Onion.MAIL_USERNAME
app.config['MAIL_PASSWORD'] = Onion.MAIL_PASSWORD
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True
mail = Mail(app)

login_manager.init_app(app)

def has_permissions():
    return current_user.Type in ['admin', 'subadmin', 'developer']

def has_admin_permissions():
    return current_user.Type in ['admin']

def send_password_reset_email(username, password, email):
    msg = Message("LuminousID password reset", sender="luminousmossbosses@gmail.com", recipients=[email])
    msg.body = "You have requested a password reset on luminousid.com for username \"" + username + "\"\n Your temporary password is: " + password + "\n"
    msg.body += "Use this temporary password to log in and then you should reset your password using the settings page IMMEDIATELY."
    mail.send(msg)

def reset_pass_and_email(email):
    user = db_session().query(User).filter(User.Email == email).first()
    rand_pass = ''.join(random.choice(string.punctuation + string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range(42))
    print rand_pass 
    user.set_password(rand_pass)
    db_session().commit()
    send_password_reset_email(user.Username, rand_pass, email)


@celery.task()
def gen_detection_images(obsid = None):
    detections = db_session().query(DetectionObject.ObjectID, DetectionObject.ParentObsID,\
            DetectionObject.Location, DetectionObject.FileName, DetectionObject.XCord,\
            DetectionObject.YCord, DetectionObject.Radius)
    if obsid != None:
        detections = detections.filter(DetectionObject.ParentObsID == obsid)
    
    for detection in detections:
        radius = detection.Radius*1.4 
        x = str(detection.XCord - radius)
        y = str(detection.YCord - radius)
        radius = radius * 2
        
        original_filename = str(db_session().query(Observation.ObsID, Observation.FileName)\
                .filter(Observation.ObsID == detection.ParentObsID).first().FileName)
        filename = str(detection.ObjectID) + "_cropped_" + original_filename
        os.system("convert " + os.path.join(app.config['UPLOAD_FOLDER'], original_filename)+ \
            " -crop " + str(radius) + "x" + str(radius) + "+" + x + "+" + y \
            + " " + os.path.join(CROPPED_FOLDER, filename))
        print filename
        save = DetectionObject.query.get(detection.ObjectID)
        save.FileName = filename
        save.Location = CROPPED_FOLDER
        db_session.commit()

@celery.task()
def gen_rotation_images(objid):
    rotations = db_session.query(RotationObject.id, RotationObject.ParentDetectionObjectID, \
            RotationObject.Location, RotationObject.FileName, RotationObject.RotationAngle) \
            .filter(RotationObject.ParentDetectionObjectID == objid)
    isPositive = db_session.query(DetectionObject).get(objid).IsPosDetect
    pos_dir = "positive/" if isPositive == 1 or isPositive == None else "negative/"

    for rotation in rotations:
        rotationangle = rotation.RotationAngle

        original_filename = str(db_session().query(DetectionObject.ObjectID, DetectionObject.FileName)\
                .filter(DetectionObject.ObjectID == rotation.ParentDetectionObjectID)\
                .first().FileName)
        print original_filename
        filename = pos_dir + str(rotation.id) + "_rotated_" + original_filename
        os.system("shell_scripts/rotate_image2.sh " + \
                os.path.join(CROPPED_FOLDER, original_filename) + " " +\
                os.path.join(ROTATED_FOLDER, filename) + " " + str(rotationangle))

        save = RotationObject.query.get(rotation.id)
        save.FileName = filename
        save.Location = ROTATED_FOLDER
        db_session.commit()

@celery.task()
def rm_detection(objectid):
    detection = db_session().query(DetectionObject.ObjectID, DetectionObject.Location, DetectionObject.FileName).filter(DetectionObject.ObjectID == objectid).first()
    if (detection != None):
        if (detection.Location != None and detection.FileName != None):
            os.system("rm " + detection.Location + "/" + detection.FileName)

@celery.task()
def rm_rotation(objectid):
    rotation = db_session().query(RotationObject.id, RotationObject.Location, RotationObject.FileName)\
            .filter(RotationObject.id == objectid).first()
    if (rotation != None):
        if (rotation.Location != None and rotation.FileName != None):
            os.system("rm " + os.path.join(rotation.Location, rotation.FileName))

@celery.task()
def id_to_db(obs_id):
    process = subprocess.Popen('python /home/ubuntu/LuminousMossBosses/Database/id_to_db.py ' + str(obs_id) + ' 2> /dev/null', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    process.wait()
    gen_detection_images(obs_id)

@celery.task()
def gen_bag_of_words(directory):
    process = subprocess.Popen('/home/ubuntu/LuminousMossBosses/BagOfWords/genxml_sb.sh ' + str(directory) + ' 2> /dev/null', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    process.wait()
    
@login_manager.unauthorized_handler
def unauthorized():
    return redirect(url_for('login'))
#def connect_db():
@app.teardown_appcontext
def shutdown_session(exception=None):
    db_session.remove()

@login_manager.user_loader
def load_user(userid):
    return User.query.get(userid)

@app.route('/')
@app.route('/index')
def home_page():
    return render_template('index.html', title = 'Home')

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        username = request.form['username'].lower()
        user = db_session().query(User).filter(User.Username == username).first()
        if user == None:
            error = 'Invalid username'
        elif not user.check_password(request.form['password']):
            error = 'Invalid password'
        else:
            #session['logged_in'] = True
            login_user(user)
            if (has_permissions()): 
                return redirect(url_for('observation_list'))
            else:
                return redirect(url_for('me'))
    return render_template('login.html', error=error)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    error = None
    if request.method == 'POST':
        username = request.form['susername'].lower()
        password = request.form['spassword']
        confirm_password = request.form['sconfirm_password']
        first = request.form['sfirst']
        last = request.form['slast']
        email = request.form['semail'].lower()
        # Need to add in check for bad passwords, unsafe first, last, username, and email
        print username
        if not checkEmptyStrings(username, password, first, last, email):
            error = 'Empty Fields'
        elif password != confirm_password:
            error = "Passwords Don't match"
        elif getSQLNoneValue(db_session().query(User.Username)\
                .filter(User.Username == username).first()) != None:
            error = 'User Already Exists'
        else:
            user = User(username, password, first, last, email) 
            db_session().add(user)
            db_session().commit()
    return render_template('login.html', error=error)

@app.route('/account_reset', methods=['GET', 'POST'])
def account_reset():
    error = None
    if request.method == 'POST':
        email = request.form['email'].lower()
        reset_pass_and_email(email)
    
    return render_template('reset_password.html', error=error)

@app.route('/me')
@login_required
def me():
        return render_template('normal_user.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    #session.pop('logged_in', None)
    return redirect(url_for('login'))

def generate_filtered_list(ufilter, items, model, attribute):
    url_filter = request.args.get(ufilter);
    page = request.args.get('page')
    page = 0 if page is None else int(page)

    if (url_filter == "null"):
        items = items.filter(getattr(model, attribute)==None)
    elif (url_filter is not None):
        items = items.filter(getattr(model, attribute)==url_filter)

    maxpage = int(items.count()/MAX_LIST_ITEMS)
    items = items.offset(page*MAX_LIST_ITEMS).limit(MAX_LIST_ITEMS).all()

    url_filter = "" if url_filter is None else "&"+ufilter+"="+url_filter
    return (items, {'page':page,'maxpage':maxpage,ufilter:url_filter})

@app.route('/observation_list')
@login_required
def observation_list():
    if has_permissions():
        query = db_session().query(Observation.ObsID, Observation.Date, Observation.IsSilene, Observation.FileName, Device.DeviceId, Device.DeviceType).outerjoin(Device, Observation.Device_id==Device.id)
        
        result = generate_filtered_list('verified', query, Observation, 'IsSilene')
        return render_template('observation_list.html', observations=result[0], urlargs=result[1])
    else:
        abort(404)

def IsProcessRunning(process):
    process = subprocess.Popen('ps -e | ' + process, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out, _ = process.communicate()
    return bool(str(out) == "")

@app.route('/_retrain_bag_of_words', methods=['POST'])
@login_required
def retrain_bag_of_word():
    if has_permissions:
        if IsProcessRunning('genxml_db.sh'):
            gen_bag_of_words.delay("static/BagOfWords")
    return "Working on it"

@app.route('/xml')
@login_required
def xml():
    if has_permissions():
        isrunning = IsProcessRunning('genxml_db.sh')
        return render_template('retraining.html',isrunning=isrunning)

@app.route('/detection_list')
@login_required
def detection_list():
    if has_permissions():
        imageid = request.args.get('imageid');
        query = db_session().query(DetectionObject.ObjectID, DetectionObject.Location, DetectionObject.FileName, DetectionObject.IsUserDetected, DetectionObject.ParentObsID)
        if imageid is not None:
            query = query.filter(DetectionObject.ParentObsID == imageid)
        result = generate_filtered_list('verified', query, DetectionObject, 'IsUserDetected')
        return render_template('detection_list.html', detections=result[0], urlargs=result[1])
    else:
        abort(404)


@app.route('/device_list')
@login_required
def device_list():
    if has_permissions():
        query = db_session().query(Device.id, Device.DeviceId, Device.DeviceType, Device.IsBlackListed, User.Username).outerjoin(User, Device.UserId == User.UserId)
        
        result = generate_filtered_list('bl', query, Device, 'IsBlackListed')
        return render_template('device_list.html', devices=result[0], urlargs=result[1])
    else:
        abort(404)

@app.route('/user_list')
@login_required
def user_list():
    #if not session.get('logged_in'):
    #    return redirect(url_for('login'))
    if has_permissions():
        query = db_session().query(User)
        result = generate_filtered_list('utype', query, User, 'Type')
        return render_template('user_list.html', users=result[0], urlargs=result[1])
    else:
        abort(404)

@app.route('/csv')
@login_required
def csv_view():
    if has_permissions():
        observations = engine.execute('select ObsID, Latitude, Longitude, LocationError, Date, Probability, count(ObjectID) as NumFlowers, isSilene, IDbyAlgorithm, DeviceId, DeviceType from observations join devices on devices.id = Device_id and DeviceType in ("iOS", "AndroidPhone", "AndroidDevice") left join detection_objects on ParentObsID = ObsID group by ObsID;')
        return render_template('download_csv.html', observations=observations)

@app.route('/save_csv')
@login_required
def csv_save():
    FileName = generateCSV()
    return send_file(FileName, as_attachment=True)
    
@app.route('/save_bag_of_words')
@login_required
def bag_of_words_save():
    Location = "static/BagOfWords/"
    vocab = Location+"vocabulary.xml"
    silene = Location+"silene.xml"
    FileName = Location+"bag_of_words.zip"
    process = subprocess.Popen('zip -jFS ' + FileName + ' ' + vocab + ' ' + silene, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    process.wait()
    return send_file(FileName, as_attachment=True)

@app.route('/observation_view')
@login_required
def observation_view():
    if has_permissions():
        page = request.args.get('imageid', 0, type=int)
        observation = db_session().query(Observation.ObsID, Observation.Date, Observation.Longitude, Observation.Latitude, Observation.IsSilene, Observation.FileName, Observation.UseForTraining, Observation.LocationError)
        obsId = db_session().query(Observation.ObsID)

        page = page if page is not None else 1

        prepage = getSQLNoneValue(obsId.order_by(Observation.ObsID.desc()).filter(Observation.ObsID < page).first())
        nextpage = getSQLNoneValue(obsId.order_by(Observation.ObsID.asc()).filter(Observation.ObsID > page).first())

        observation = observation.filter(Observation.ObsID == page).first()
        urlargs = {'page':page,'prepage':prepage,'nextpage':nextpage}
        return render_template('image_viewer.html', observation=observation, urlargs=urlargs)
    else:
        abort(404)

@app.route('/detection_view')
@login_required
def detection_view():
    if has_permissions():
        page = request.args.get('detectionid', 0, type=int)

        page = page if page is not None else 1

        detId = db_session().query(DetectionObject.ObjectID)
        prepage = getSQLNoneValue(detId.order_by(DetectionObject.ObjectID.desc()).filter(DetectionObject.ObjectID < page).first())
        nextpage = getSQLNoneValue(detId.order_by(DetectionObject.ObjectID.asc()).filter(DetectionObject.ObjectID > page).first())

        detection = db_session().query(DetectionObject.IsPosDetect, DetectionObject.IsUserDetected, Observation.ObsID, Observation.FileName).outerjoin(Observation, Observation.ObsID == DetectionObject.ParentObsID).filter(DetectionObject.ObjectID == page).first()

        urlargs = {'page':page,'prepage':prepage,'nextpage':nextpage}
        return render_template('rotation.html', detection=detection, urlargs=urlargs)
    else:
        abort(404)

@app.route('/settings', methods=['GET', 'POST'])
@login_required
def settings():
    error = None
    if has_permissions():
        if request.method == 'POST':
            if not current_user.check_password(request.form['password']):
                error = 'Invalid password'
            elif request.form['spassword'] != request.form['sconfirm_password']:
                error = 'Passwords Do Not Match'
            else:
                current_user.set_password(request.form['spassword'])
                db_session().commit()

        return render_template('settings.html', error=error)
    
@app.route('/_get_observation_data')
@login_required
def get_observation_data():
    page = request.args.get('imageid', 0, type=int)
    observation = db_session().query(Observation.FileName).filter(Observation.ObsID == page).first()
    observation_object = db_session().query(DetectionObject.ObjectID, DetectionObject.XCord, DetectionObject.YCord, DetectionObject.Radius, DetectionObject.IsUserDetected, DetectionObject.IsPosDetect).filter(DetectionObject.ParentObsID == page).all()
    circles = []
    for obj in observation_object:
        circles.append({'XCord':obj.XCord,'YCord':obj.YCord,'Radius':obj.Radius,'IsUserDetected':obj.IsUserDetected,\
                'IsPosDetect':obj.IsPosDetect, 'ObjectID':obj.ObjectID})
    return jsonify(FileName=observation.FileName, circles=circles) 

@app.route('/_get_detection_data')
@login_required
def get_detection_data():
    page = request.args.get('detectionid', 0, type=int)
    print page
    detection = db_session().query(DetectionObject.FileName, DetectionObject.Location).filter(DetectionObject.ObjectID == page).first()
    rotations = db_session().query(RotationObject.RotationAngle, RotationObject.id, RotationObject.ParentDetectionObjectID).filter(RotationObject.ParentDetectionObjectID == page).all()
    lines = []
    for rotation in rotations:
        print rotation.RotationAngle
        lines.append({'RotationAngle':rotation.RotationAngle, 'id':rotation.id})
    return jsonify(FileName=detection.FileName, Location=detection.Location, lines=lines) 

def update_isValue(module, attribute):
    data = {'error':None, 'results':None}
    if has_permissions():
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
@login_required
def update_isSilene():
    return jsonify(data=update_isValue(Observation, 'IsSilene'))

@app.route('/_update_useForTraining', methods=["POST"])
@login_required
def update_useForTraining():
    return jsonify(data=update_isValue(Observation, 'UseForTraining'))

@app.route('/_update_isBlackListed', methods=["POST"])
@login_required
def update_isBlackListed():
    return jsonify(data=update_isValue(Device, 'IsBlackListed'))

@app.route('/_update_UserType', methods=["POST"])
@login_required
def update_UserType():
    data = {'error':None, 'results':None}
    if has_admin_permissions():
        try:
            value = request.form.get('sentValue')
            value_id = request.form.get('sentId', type=int)
            user = db_session().query(User).get(value_id)
            user.Type = value
            data['results'] = "Updated value"
            db_session().commit()
        except Exception, e:
            data['error'] = str(e)
            data['results'] = "Failed to update values"
    return jsonify(data=data)

@app.route('/_update_detectionObjects', methods=["POST"])
@login_required
def update_detectionObjects():
    data = {'error':None, 'results':None}
    if has_permissions():
        detectionObjects = json.loads(request.form.get('sentValue'))
        observationId = request.form.get('sentId')
        for obj in detectionObjects:
            if obj['id'] == None and not obj['removed']:
                obj_db = DetectionObject(obj['x'], obj['y'], obj['r'], not obj['falsePositive'], 1, observationId)
                db_session().add(obj_db)
            elif obj['id'] != None:
                obj_db = db_session().query(DetectionObject).get(obj['id'])
                if not obj['removed']:
                    obj_db.IsPosDetect = not obj['falsePositive']
                elif obj['removed'] and bool(obj_db.IsUserDetected):
                    rm_detection.delay(obj_db.ObjectID)
                    db_session().delete(obj_db)
        db_session().commit()
        gen_detection_images.delay(observationId)
    return jsonify(data=data)

@app.route('/_update_rotationObjects', methods=["POST"])
@login_required
def update_rotationObjects():
    data = {'error':None, 'results':None}
    if has_permissions():
        rotationObjects = json.loads(request.form.get('sentValue'))
        detectionId = request.form.get('sentId')
        
        dbRotations = db_session().query(RotationObject.id, RotationObject.ParentDetectionObjectID) \
            .filter(RotationObject.ParentDetectionObjectID == detectionId)
        existing_id_list = [dbRotation.id for dbRotation in dbRotations]
        sent_id_list = []
        for obj in rotationObjects:
            if obj['id'] == None:
                rotation_db = RotationObject(detectionId, obj['angle'])
                db_session().add(rotation_db)
            sent_id_list.append(obj['id'])
        remove_list = list(set(existing_id_list) - set(sent_id_list))
        for remove_item in remove_list:
            rotation_db = db_session().query(RotationObject).get(remove_item)
            rm_rotation.delay(rotation_db.id)
            db_session().delete(rotation_db)
        db_session().commit()
        gen_rotation_images.delay(detectionId)
    return jsonify(data=data)


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
        LocationError = float(Obs['LocationError'])

        if not checkValuesExist(Latitude, Longitude, DeviceId, DeviceType, LocationError):
            raise ValueError('Values cannot be null')

        if DeviceType not in ALLOWED_DEVICES:
            raise ValueError('Device not allowed')

        # Check if phone is in the database
        device = db_session.query(Device.id, Device.IsBlackListed).filter(and_( \
            Device.DeviceId == DeviceId, \
            Device.DeviceType == DeviceType)).first()

        if device is None:
            device = Device(DeviceId, DeviceType)
            db_session().add(device)
            db_session().commit()
       
        if bool(device.IsBlackListed):
            raise ValueError('Device not allowed')
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

        observation = Observation(Time, Date, Latitude, Longitude, LocationError, filename, UPLOAD_FOLDER, device.id) 
        db_session().add(observation)
        db_session().flush()
        db_session().refresh(observation)
        obs_id =  observation.ObsID
        db_session().commit()
        print obs_id
        id_to_db.delay(obs_id)
        results = "sent"
        errors = None

    except Exception,e:
        #print e
        results = "failed"
        errors = e.message + " " + repr(e)

    return jsonify(results=results, errors=errors)

    
def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5003)
