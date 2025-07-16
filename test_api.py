#!/usr/bin/env python3
"""
Test suite for the API endpoints
"""

import unittest
import json
import jwt
import datetime
from api import app, users_db

class APITestCase(unittest.TestCase):
    """Test case for the API endpoints"""

    def setUp(self):
        """Set up test client and other test variables"""
        self.app = app.test_client()
        self.app.testing = True
        
        # Generate a test token
        self.test_token = jwt.encode({
            'username': 'user1',
            'role': 'admin',
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
        }, app.config['SECRET_KEY'], algorithm="HS256")

    def test_login_success(self):
        """Test user login with valid credentials"""
        response = self.app.post(
            '/api/login',
            data=json.dumps({'username': 'user1', 'password': 'password1'}),
            content_type='application/json'
        )
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('token' in data)

    def test_login_failure(self):
        """Test user login with invalid credentials"""
        response = self.app.post(
            '/api/login',
            data=json.dumps({'username': 'user1', 'password': 'wrong_password'}),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, 401)

    def test_get_all_items(self):
        """Test getting all items with valid token"""
        response = self.app.get(
            '/api/items',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertTrue(isinstance(data, list))

    def test_get_all_items_no_token(self):
        """Test getting all items without token"""
        response = self.app.get('/api/items')
        self.assertEqual(response.status_code, 401)

    def test_create_item(self):
        """Test creating a new item"""
        response = self.app.post(
            '/api/items',
            data=json.dumps({'name': 'Test Item', 'description': 'Test Description'}),
            content_type='application/json',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.data)
        self.assertEqual(data['name'], 'Test Item')
        self.assertEqual(data['description'], 'Test Description')

    def test_get_specific_item(self):
        """Test getting a specific item"""
        # First create an item
        create_response = self.app.post(
            '/api/items',
            data=json.dumps({'name': 'Get Test Item', 'description': 'Get Test Description'}),
            content_type='application/json',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        item_id = json.loads(create_response.data)['id']
        
        # Then get the item
        response = self.app.get(
            f'/api/items/{item_id}',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['name'], 'Get Test Item')

    def test_update_item(self):
        """Test updating an item"""
        # First create an item
        create_response = self.app.post(
            '/api/items',
            data=json.dumps({'name': 'Update Test Item', 'description': 'Update Test Description'}),
            content_type='application/json',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        item_id = json.loads(create_response.data)['id']
        
        # Then update the item
        response = self.app.put(
            f'/api/items/{item_id}',
            data=json.dumps({'name': 'Updated Item', 'description': 'Updated Description'}),
            content_type='application/json',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['name'], 'Updated Item')
        self.assertEqual(data['description'], 'Updated Description')

    def test_delete_item(self):
        """Test deleting an item"""
        # First create an item
        create_response = self.app.post(
            '/api/items',
            data=json.dumps({'name': 'Delete Test Item', 'description': 'Delete Test Description'}),
            content_type='application/json',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        item_id = json.loads(create_response.data)['id']
        
        # Then delete the item
        response = self.app.delete(
            f'/api/items/{item_id}',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['message'], 'Item deleted successfully')
        
        # Verify item is deleted
        get_response = self.app.get(
            f'/api/items/{item_id}',
            headers={'Authorization': f'Bearer {self.test_token}'}
        )
        self.assertEqual(get_response.status_code, 404)

    def test_get_api_docs(self):
        """Test getting API documentation"""
        response = self.app.get('/api/docs')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertTrue('endpoints' in data)
        self.assertTrue(isinstance(data['endpoints'], list))
        self.assertTrue(len(data['endpoints']) > 0)

if __name__ == '__main__':
    unittest.main()