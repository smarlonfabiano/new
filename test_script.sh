#!/bin/bash

# Make the script executable
chmod +x text2leetspeak.sh

echo "=== Testing with file input ==="
./text2leetspeak.sh test.txt

echo -e "\n=== Testing with standard input ==="
echo "Hello World! This is a test." | ./text2leetspeak.sh