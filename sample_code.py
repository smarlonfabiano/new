#!/usr/bin/env python3
# This is a sample Python file to demonstrate the business logic analyzer

class UserAccount:
    """
    Represents a user account with validation and business rules
    """
    def __init__(self, username, email, password):
        self.username = username
        self.email = email
        self.password = password
        self.is_active = False
        self.login_attempts = 0
        
    def validate_email(self):
        """Validates email format"""
        import re
        # Email validation pattern
        pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
        if re.match(pattern, self.email):
            return True
        else:
            raise ValueError("Invalid email format")
    
    def validate_password_strength(self):
        """
        Business rule: Password must be at least 8 characters long
        and contain at least one number and one special character
        """
        import re
        if len(self.password) < 8:
            return False
        
        # Check for at least one digit
        if not re.search(r'\d', self.password):
            return False
            
        # Check for at least one special character
        if not re.search(r'[!@#$%^&*(),.?":{}|<>]', self.password):
            return False
            
        return True
    
    def activate_account(self):
        """Business logic for account activation"""
        if self.validate_email():
            if self.validate_password_strength():
                self.is_active = True
                return True
            else:
                raise ValueError("Password does not meet security requirements")
        return False
    
    def process_login(self, entered_password):
        """
        Process login attempt with business rules:
        - Account must be active
        - Password must match
        - Account locks after 3 failed attempts
        """
        if not self.is_active:
            return {"success": False, "message": "Account is not active"}
        
        if self.login_attempts >= 3:
            return {"success": False, "message": "Account is locked due to too many failed attempts"}
        
        if entered_password != self.password:
            self.login_attempts += 1
            remaining_attempts = 3 - self.login_attempts
            return {
                "success": False, 
                "message": f"Invalid password. {remaining_attempts} attempts remaining"
            }
        
        # Reset login attempts on successful login
        self.login_attempts = 0
        return {"success": True, "message": "Login successful"}


# Data processing workflow example
def process_user_data(user_data):
    """
    Process user data from various sources and formats
    """
    processed_users = []
    
    for data in user_data:
        # Data transformation
        if 'name' in data:
            # Transform name to username format
            username = data['name'].lower().replace(' ', '_')
        else:
            username = f"user_{len(processed_users)}"
        
        # Data validation
        if 'email' not in data:
            continue  # Skip records without email
        
        # Create standardized user record
        processed_user = {
            'username': username,
            'email': data['email'],
            'role': data.get('role', 'user'),
            'active': data.get('active', True)
        }
        
        processed_users.append(processed_user)
    
    return processed_users


# Database interaction example
def save_users_to_database(users):
    """
    Simulates saving users to a database with proper error handling
    """
    try:
        # This would be a database connection in a real application
        db = {"connected": True, "users": []}
        
        if not db["connected"]:
            raise ConnectionError("Database connection failed")
        
        # Insert each user with validation
        for user in users:
            # Validate required fields
            if not all(key in user for key in ['username', 'email']):
                print(f"Skipping invalid user record: {user}")
                continue
                
            # Check for duplicate usernames
            if any(u['username'] == user['username'] for u in db['users']):
                print(f"Username already exists: {user['username']}")
                continue
                
            # Insert user
            db['users'].append(user)
            print(f"User {user['username']} saved successfully")
            
        return True
        
    except Exception as e:
        print(f"Database error: {str(e)}")
        return False


# API interaction example
def fetch_user_data_from_api(api_url):
    """
    Fetches user data from an external API with error handling
    """
    import json
    
    try:
        # Simulate API request
        print(f"Fetching data from {api_url}")
        
        # This would be a real HTTP request in a production application
        # response = requests.get(api_url)
        # response.raise_for_status()
        
        # Simulate API response
        api_response = """
        {
            "users": [
                {"name": "John Doe", "email": "john@example.com", "role": "admin"},
                {"name": "Jane Smith", "email": "jane@example.com"}
            ]
        }
        """
        
        # Parse JSON response
        data = json.loads(api_response)
        
        # Process and validate the data
        if 'users' not in data:
            raise ValueError("Invalid API response format")
            
        return data['users']
        
    except json.JSONDecodeError:
        print("Error: Invalid JSON response from API")
        return []
    except Exception as e:
        print(f"API error: {str(e)}")
        return []


# Main workflow demonstrating business logic, validation, and data processing
def main():
    # Fetch data from API
    users_data = fetch_user_data_from_api("https://api.example.com/users")
    
    # Process the data
    processed_users = process_user_data(users_data)
    
    # Save to database
    save_users_to_database(processed_users)
    
    # Create and activate a user account
    try:
        user = UserAccount(
            username="new_user",
            email="user@example.com",
            password="Secure123!"
        )
        
        if user.activate_account():
            print("User account activated successfully")
            
            # Test login
            login_result = user.process_login("Secure123!")
            print(f"Login attempt: {login_result['message']}")
            
    except ValueError as e:
        print(f"Error: {str(e)}")


if __name__ == "__main__":
    main()