from sqlalchemy import Column, String, Text
from sqlalchemy.orm import relationship
from .base import Base, BaseModel

class Category(Base, BaseModel):
    """Category model for organizing products"""
    
    __tablename__ = 'categories'
    
    name = Column(String(100), nullable=False, unique=True)
    description = Column(Text)
    
    # Relationships
    products = relationship("Product", back_populates="category")
    
    def __repr__(self):
        return f"<Category {self.name}>"