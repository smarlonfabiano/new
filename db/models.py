"""
Database models using SQLAlchemy ORM
"""

from datetime import datetime
from sqlalchemy import Column, Integer, String, Float, ForeignKey, Table, DateTime, Text, Numeric
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

# Association table for many-to-many relationship between products and categories
product_categories = Table(
    'product_categories',
    Base.metadata,
    Column('product_id', Integer, ForeignKey('products.id'), primary_key=True),
    Column('category_id', Integer, ForeignKey('categories.id'), primary_key=True)
)

class User(Base):
    """User model representing system users"""
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    orders = relationship("Order", back_populates="user", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<User(username='{self.username}', email='{self.email}')>"

class Product(Base):
    """Product model representing items for sale"""
    __tablename__ = 'products'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    price = Column(Numeric(10, 2), nullable=False)
    stock_quantity = Column(Integer, nullable=False, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    order_items = relationship("OrderItem", back_populates="product")
    categories = relationship("Category", secondary=product_categories, back_populates="products")
    
    def __repr__(self):
        return f"<Product(name='{self.name}', price={self.price})>"

class Order(Base):
    """Order model representing customer purchases"""
    __tablename__ = 'orders'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    order_date = Column(DateTime, default=datetime.utcnow)
    status = Column(String(20), nullable=False, default='pending')
    total_amount = Column(Numeric(10, 2), nullable=False)
    
    # Relationships
    user = relationship("User", back_populates="orders")
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Order(id={self.id}, user_id={self.user_id}, status='{self.status}')>"

class OrderItem(Base):
    """OrderItem model representing items in an order"""
    __tablename__ = 'order_items'
    
    id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey('orders.id'), nullable=False)
    product_id = Column(Integer, ForeignKey('products.id'), nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price = Column(Numeric(10, 2), nullable=False)
    
    # Relationships
    order = relationship("Order", back_populates="items")
    product = relationship("Product", back_populates="order_items")
    
    def __repr__(self):
        return f"<OrderItem(order_id={self.order_id}, product_id={self.product_id}, quantity={self.quantity})>"

class Category(Base):
    """Category model for product categorization"""
    __tablename__ = 'categories'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False)
    description = Column(Text)
    
    # Relationships
    products = relationship("Product", secondary=product_categories, back_populates="categories")
    
    def __repr__(self):
        return f"<Category(name='{self.name}')>"