# Simple Issue Tracker

A command-line tool for tracking issues.

## Features

- Add new issues with title and description
- List all issues
- Filter issues by status
- Update existing issues

## Installation

No installation required. Just make sure the script is executable:

```bash
chmod +x issue_tracker
```

## Usage

### List all issues

To list all issues in the system:

```bash
./issue_tracker list
```

This will display all issues with their ID, title, and status.

### Add a new issue

To add a new issue:

```bash
./issue_tracker add "Issue Title" "Issue Description"
```

### Update an issue

To update an issue:

```bash
./issue_tracker update ISSUE_ID --title "New Title" --description "New Description" --status "closed"
```

You can update any combination of title, description, and status.

### Filter issues by status

To list issues with a specific status:

```bash
./issue_tracker list --status "open"
```

Common statuses include "open", "in progress", and "closed".

## Running Tests

To run the unit tests:

```bash
python3 test_issue_tracker.py
```

## File Storage

Issues are stored in a JSON file (`issues.json`) in the same directory as the script.