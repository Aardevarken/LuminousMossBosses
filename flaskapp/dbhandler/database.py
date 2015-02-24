from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

# Configuration
engine = create_engine('mysql://%s:%s@%s/%s' % ('jamie', 'luciDMoss', 'localhost', 'luminous_db'), echo=False)
db_session = scoped_session(sessionmaker(autocommit=False,autoflush=False,bind=engine))

Base = declarative_base()
Base.query = db_session.query_property()

def init_db():
    import dbhandler.models
    Base.metadata.create_all(bind=engine)

