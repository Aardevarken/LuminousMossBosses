BROKER_URL='redis://localhost:5000/0'
CELERY_IMPORTS = ('app', )
CELERY_RESULT_BACKEND='redis://localhost:5000/0'
