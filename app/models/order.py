from sqlalchemy import Column, String, Float, Integer, ForeignKey, Enum, Text
from sqlalchemy.orm import relationship
from .base import Base, BaseModel
import enum

class OrderStatus(enum.Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"

class Order(Base, BaseModel):
    """Order model representing customer purchases"""
    
    __tablename__ = 'orders'
    
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    status = Column(Enum(OrderStatus), default=OrderStatus.PENDING)
    total_amount = Column(Float, nullable=False)
    shipping_address = Column(Text)
    tracking_number = Column(String(100))
    
    # Relationships
    user = relationship("User", back_populates="orders")
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Order {self.id}>"

class OrderItem(Base, BaseModel):
    """OrderItem model representing individual items in an order"""
    
    __tablename__ = 'order_items'
    
    order_id = Column(Integer, ForeignKey('orders.id'), nullable=False)
    product_id = Column(Integer, ForeignKey('products.id'), nullable=False)
    quantity = Column(Integer, nullable=False, default=1)
    price_at_purchase = Column(Float, nullable=False)
    
    # Relationships
    order = relationship("Order", back_populates="items")
    product = relationship("Product", back_populates="order_items")
    
    def __repr__(self):
        return f"<OrderItem {self.id}>"