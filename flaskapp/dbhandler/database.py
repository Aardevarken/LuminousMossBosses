from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

# Configuration
engine = create_engine('mysql://%s:%s@%s/%s' % ('flaskapi', 'totallynotapassword', 'localhost', 'luminous_db'), echo=False)

engine2 = create_engine('mysql://%s:%s@%s/%s' % ('researcher', 'sileneisawesome', 'localhost', 'luminous_db'), echo=False)
db_session = scoped_session(sessionmaker(autocommit=False,autoflush=False,bind=engine))
db_update = scoped_session(sessionmaker(autocommit=False,autoflush=False,bind=engine2))

Base = declarative_base()
Base.query = db_session.query_property()

def init_db():
    import dbhandler.models
    Base.metadata.create_all(bind=engine)

