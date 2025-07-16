# Database Schema Analysis Tool

This repository contains a database schema analysis tool that examines and reports on database schemas, relationships, and data models implemented in the system.

## Project Structure

```
.
├── app/
│   ├── models/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── user.py
│   │   ├── product.py
│   │   ├── category.py
│   │   └── order.py
│   └── database.py
├── tests/
│   └── test_schema_analysis.py
├── analyze_db_schema.sh
└── README.md
```

## Database Models

The system implements the following database models:

1. **User**: Represents system users with authentication details
2. **Product**: Represents items available for purchase
3. **Category**: Organizes products into logical groups
4. **Order**: Tracks customer purchases
5. **OrderItem**: Represents individual items within an order

## Schema Analysis Script

The `analyze_db_schema.sh` script examines the database models in the system and provides a comprehensive report on:

- Table schemas and column definitions
- Relationships between tables
- Foreign key constraints
- Entity-relationship diagram (text description)
- Database configuration

## Running the Analysis

To analyze the database schema:

```bash
chmod +x analyze_db_schema.sh
./analyze_db_schema.sh
```

## Running Tests

To run the tests:

```bash
python -m unittest tests/test_schema_analysis.py
```

## Implementation Details

The database models are implemented using SQLAlchemy ORM with the following relationships:

- Users have many Orders (one-to-many)
- Categories have many Products (one-to-many)
- Products belong to one Category (many-to-one)
- Orders have many OrderItems (one-to-many)
- Products can be in many OrderItems (one-to-many)
- OrderItems belong to one Order and one Product (many-to-one)