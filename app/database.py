from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from app.models import Base

# Database configuration
DATABASE_URL = "sqlite:///app.db"  # Using SQLite for simplicity

# Create engine
engine = create_engine(DATABASE_URL)

# Create session factory
session_factory = sessionmaker(bind=engine)
Session = scoped_session(session_factory)

# Function to initialize the database
def init_db():
    Base.metadata.create_all(engine)

# Function to get a database session
def get_db_session():
    return Session()

# Function to close the session
def close_db_session():
    Session.remove()