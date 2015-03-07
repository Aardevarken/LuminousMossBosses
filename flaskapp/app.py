from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify
import json, sha
from dbhandler.database import db_session
from dbhandler.models import Observation, DetectionObject 

# configuration
DEBUG = False# Change this to false when put into production 
SECRET_KEY = '90b70bfa992696d63140ca63fcb035cf'
USERNAME = 'admin'
PASSWORD = '19b95897c63fcc7b81d90396ce28bf94dedc67e9'

UPLOAD_FOLDER ='/work/pics/pending/all' 
THUMBNAIL_FOLDER = '/work/pics/thumbnail'
ALLOWED_EXTENSIONS = set(['jpg', 'jpeg'])

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

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('login'))

@app.route('/observation_list')
def observation_list():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    listItemCount = 15

    verified = request.args.get('verified')
    page = request.args.get('page')
    page = 0 if page is None else int(page)
    observations = db_session().query(Observation.ObsID, Observation.Date, Observation.IsSilene, Observation.FileName)
    
    if (verified == "null"):
        observations = observations.filter(Observation.IsSilene==None)
    elif (verified is not None):
        observations = observations.filter(Observation.IsSilene==verified)

    maxpage = int(observations.count()/listItemCount)        
    observations = observations.offset(page*listItemCount).limit(listItemCount).all()

    verified = "" if verified is None else "&verified="+verified
    urlargs = {'page':page,'maxpage':maxpage,'verified':verified}
    return render_template('list_view.html', observations=observations, urlargs=urlargs)

@app.route('/observation_view')
def observation_view():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    page = request.args.get('imageid', 0, type=int)
    observation = db_session().query(Observation.ObsID, Observation.Date, Observation.Longitude, Observation.Latitude, Observation.IsSilene, Observation.FileName)
    maxpage = int(observation.count())
    page = page if page is not None else 1
    observation = observation.filter(Observation.ObsID == page).first()
    urlargs = {'page':page,'maxpage':maxpage}
    return render_template('image_viewer.html', observation=observation, urlargs=urlargs)

@app.route('/_get_observation_data')
def get_observation_data():
    #if not session.get('logged_in'):
    #    return redirect(url_for('login'))
    page = request.args.get('imageid', 0, type=int)
    observation = db_session().query(Observation.FileName).filter(Observation.ObsID == page).first()
    observation_object = db_session().query(DetectionObject.XCord, DetectionObject.YCord, DetectionObject.Radius, DetectionObject.IsUserDetected).filter(DetectionObject.ParentObsID == page).all()
    circles = []
    for obj in observation_object:
        circles.append({'XCord':obj.XCord,'YCord':obj.YCord,'Radius':obj.Radius,'IsUserDetected':obj.IsUserDetected})
    return jsonify(FileName=observation.FileName, circles=circles) 

#We need to add in a requirement that user must be logged in to even access this page
@app.route('/_update_isSilene', methods=["POST"])
def update_isSilene():
    if not session.get('logged_in'):
        return "I can't let you do that Dave" 
    
    observation_value = request.form.get('sentValue', type=int)
    observation_value = bool(observation_value) if observation_value != -1 else None
    observation_id = request.form.get('sentId', type=int)
    Observation.query.get(observation_id).IsSilene = observation_value
    db_session().commit()

    return jsonify(flash="values updated")

@app.route('/_post_observation', methods=["POST"])
def post_observation():
    # Get Data
    data = request.get_json().get('username')
    Obs = data.Obs
    Detections = data.Detections

    # Get File
    file = request.files['file']
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

    observation = Observation(Obs.Time, Obs.Date, Obs.Latitude, Obs.Longitude, Obs.Username, IsSilene=False, UseForTraining=False, file.filename); 
    
    db_session().add(observation);
    for detection in Detections:
        detectionObj = detection_objects(detection.XCord, detection.YCord, detection.Radius, True, Observation.ObsID);
        db_session().add(detectionObj)
    
    results = "observation recieved"
    return jsonify(results=results)

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5003)
