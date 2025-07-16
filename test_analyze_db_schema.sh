#!/bin/bash

# Unit tests for the database schema analysis script

# Create a temporary test directory
TEST_DIR=$(mktemp -d)
echo "Created temporary test directory: $TEST_DIR"

# Clean up function to be called on exit
cleanup() {
    echo "Cleaning up test directory..."
    rm -rf "$TEST_DIR"
}

# Register the cleanup function to be called on exit
trap cleanup EXIT

# Function to run a test and check if the output contains expected text
run_test() {
    local test_name="$1"
    local expected_text="$2"
    local command="$3"
    
    echo "Running test: $test_name"
    
    # Run the command and capture output
    local output
    output=$($command)
    
    # Check if output contains expected text
    if echo "$output" | grep -q "$expected_text"; then
        echo "✅ PASS: $test_name"
        return 0
    else
        echo "❌ FAIL: $test_name"
        echo "Expected to find: $expected_text"
        echo "Output was:"
        echo "$output"
        return 1
    fi
}

# Test 1: Basic script execution
echo "Test 1: Basic script execution"
run_test "Script executes without errors" "Database Schema Analysis Complete" "bash analyze_db_schema.sh $TEST_DIR"

# Test 2: SQL file detection and analysis
echo -e "\nTest 2: SQL file detection and analysis"
mkdir -p "$TEST_DIR/sql"
cat > "$TEST_DIR/sql/schema.sql" << 'EOF'
CREATE TABLE users (id INT PRIMARY KEY, name VARCHAR(100));
CREATE TABLE posts (id INT PRIMARY KEY, user_id INT, FOREIGN KEY (user_id) REFERENCES users(id));
EOF

run_test "SQL file detection" "Found 1 SQL files" "bash analyze_db_schema.sh $TEST_DIR"
run_test "SQL table detection" "CREATE TABLE users" "bash analyze_db_schema.sh $TEST_DIR"
run_test "SQL foreign key detection" "FOREIGN KEY" "bash analyze_db_schema.sh $TEST_DIR"

# Test 3: Django models detection
echo -e "\nTest 3: Django models detection"
mkdir -p "$TEST_DIR/django/app"
cat > "$TEST_DIR/django/app/models.py" << 'EOF'
from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)

class Post(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
EOF

run_test "Django models file detection" "Found 1 Django model files" "bash analyze_db_schema.sh $TEST_DIR"
run_test "Django model class detection" "class User" "bash analyze_db_schema.sh $TEST_DIR"
run_test "Django relationship detection" "ForeignKey" "bash analyze_db_schema.sh $TEST_DIR"

# Test 4: Rails schema detection
echo -e "\nTest 4: Rails schema detection"
mkdir -p "$TEST_DIR/db"
cat > "$TEST_DIR/db/schema.rb" << 'EOF'
ActiveRecord::Schema.define(version: 2023_01_01_000000) do
  create_table "users", force: :cascade do |t|
    t.string "name", null: false
  end
  
  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id", null: false
  end
  
  add_foreign_key "posts", "users"
end
EOF

run_test "Rails schema detection" "Ruby on Rails schema.rb" "bash analyze_db_schema.sh $TEST_DIR"
run_test "Rails table detection" "create_table \"users\"" "bash analyze_db_schema.sh $TEST_DIR"
run_test "Rails foreign key detection" "add_foreign_key" "bash analyze_db_schema.sh $TEST_DIR"

# Test 5: Java entity detection
echo -e "\nTest 5: Java entity detection"
mkdir -p "$TEST_DIR/java/src/main/java/com/example/entity"
cat > "$TEST_DIR/java/src/main/java/com/example/entity/User.java" << 'EOF'
package com.example.entity;

import javax.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name")
    private String name;
    
    @OneToMany(mappedBy = "user")
    private List<Post> posts;
}
EOF

run_test "Java entity detection" "Java Hibernate/JPA Entities" "bash analyze_db_schema.sh $TEST_DIR"
run_test "Java entity annotation detection" "@Entity" "bash analyze_db_schema.sh $TEST_DIR"
run_test "Java relationship detection" "@OneToMany" "bash analyze_db_schema.sh $TEST_DIR"

echo -e "\nAll tests completed!"