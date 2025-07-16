-- SQL Query to fetch data from the database
-- Backend API is hosted at api.example.com (IP: 192.168.1.100)

SELECT 
    user_id,
    username,
    email,
    created_at
FROM 
    users
WHERE 
    status = 'active'
ORDER BY 
    created_at DESC
LIMIT 100;