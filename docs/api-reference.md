# API Reference

This document provides details about the API functions available in this project.

## Utility Functions

### Greeting Module

Located in `src/utils/greeting.js`

#### `greet(name)`

Creates a greeting message for the given name.

**Parameters:**
- `name` (string): The name to greet

**Returns:**
- (string): The greeting message

**Example:**
```javascript
const { greet } = require('./utils/greeting');
const message = greet('World'); // Returns: "Hello, World!"
```

## Main Application

Located in `src/index.js`

### `main()`

Main function that runs when the application starts.

**Parameters:**
- None

**Returns:**
- None (logs messages to console)

**Example:**
```javascript
const { main } = require('./src/index');
main(); // Logs: "Application started" and "Hello, World!"
```