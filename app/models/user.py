from sqlalchemy import Column, String, Boolean
from sqlalchemy.orm import relationship
from .base import Base, BaseModel

class User(Base, BaseModel):
    """User model representing system users"""
    
    __tablename__ = 'users'
    
    email = Column(String(255), unique=True, nullable=False, index=True)
    username = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    first_name = Column(String(100))
    last_name = Column(String(100))
    is_active = Column(Boolean, default=True)
    is_admin = Column(Boolean, default=False)
    
    # Relationships
    orders = relationship("Order", back_populates="user")
    
    def __repr__(self):
        return f"<User {self.username}>"