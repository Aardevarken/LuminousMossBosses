#!/user/bin/python
import sys
sys.path.insert(0,'/var/www/flaskapp')


from app import app as application
application.secret_key = '90b70bfa992696d63140ca63fcb035cf'
