from sqlalchemy import Column, String, Float, Integer, ForeignKey, Text, Boolean
from sqlalchemy.orm import relationship
from .base import Base, BaseModel

class Product(Base, BaseModel):
    """Product model representing items for sale"""
    
    __tablename__ = 'products'
    
    name = Column(String(255), nullable=False)
    description = Column(Text)
    price = Column(Float, nullable=False)
    stock_quantity = Column(Integer, default=0)
    sku = Column(String(50), unique=True)
    is_available = Column(Boolean, default=True)
    category_id = Column(Integer, ForeignKey('categories.id'))
    
    # Relationships
    category = relationship("Category", back_populates="products")
    order_items = relationship("OrderItem", back_populates="product")
    
    def __repr__(self):
        return f"<Product {self.name}>"