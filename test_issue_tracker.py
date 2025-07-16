#!/usr/bin/env python3
"""
Unit tests for the issue tracker.
"""

import os
import unittest
import tempfile
import json
from issue_tracker import Issue, IssueTracker


class TestIssueTracker(unittest.TestCase):
    """Test cases for the issue tracker."""
    
    def setUp(self):
        """Set up a temporary file for testing."""
        self.temp_file = tempfile.NamedTemporaryFile(delete=False)
        self.temp_file.close()
        self.tracker = IssueTracker(self.temp_file.name)
    
    def tearDown(self):
        """Clean up temporary files."""
        if os.path.exists(self.temp_file.name):
            os.unlink(self.temp_file.name)
    
    def test_add_issue(self):
        """Test adding an issue."""
        issue = self.tracker.add_issue("Test Issue", "This is a test issue")
        self.assertEqual(issue.title, "Test Issue")
        self.assertEqual(issue.description, "This is a test issue")
        self.assertEqual(issue.status, "open")
        self.assertEqual(issue.issue_id, 1)
    
    def test_list_issues_empty(self):
        """Test listing issues when there are none."""
        issues = self.tracker.list_issues()
        self.assertEqual(len(issues), 0)
    
    def test_list_issues(self):
        """Test listing issues."""
        # Add some issues
        self.tracker.add_issue("Issue 1", "Description 1")
        self.tracker.add_issue("Issue 2", "Description 2")
        self.tracker.add_issue("Issue 3", "Description 3")
        
        # List all issues
        issues = self.tracker.list_issues()
        self.assertEqual(len(issues), 3)
        self.assertEqual(issues[0].title, "Issue 1")
        self.assertEqual(issues[1].title, "Issue 2")
        self.assertEqual(issues[2].title, "Issue 3")
    
    def test_list_issues_with_status(self):
        """Test listing issues filtered by status."""
        # Add some issues with different statuses
        issue1 = self.tracker.add_issue("Issue 1", "Description 1")
        issue2 = self.tracker.add_issue("Issue 2", "Description 2")
        issue3 = self.tracker.add_issue("Issue 3", "Description 3")
        
        # Update statuses
        self.tracker.update_issue(issue1.issue_id, status="closed")
        self.tracker.update_issue(issue2.issue_id, status="in progress")
        
        # List open issues
        open_issues = self.tracker.list_issues("open")
        self.assertEqual(len(open_issues), 1)
        self.assertEqual(open_issues[0].title, "Issue 3")
        
        # List closed issues
        closed_issues = self.tracker.list_issues("closed")
        self.assertEqual(len(closed_issues), 1)
        self.assertEqual(closed_issues[0].title, "Issue 1")
        
        # List in-progress issues
        in_progress_issues = self.tracker.list_issues("in progress")
        self.assertEqual(len(in_progress_issues), 1)
        self.assertEqual(in_progress_issues[0].title, "Issue 2")
    
    def test_get_issue(self):
        """Test getting an issue by ID."""
        # Add an issue
        issue = self.tracker.add_issue("Test Issue", "This is a test issue")
        
        # Get the issue
        retrieved_issue = self.tracker.get_issue(issue.issue_id)
        self.assertEqual(retrieved_issue.title, "Test Issue")
        self.assertEqual(retrieved_issue.description, "This is a test issue")
        
        # Try to get a non-existent issue
        non_existent_issue = self.tracker.get_issue(999)
        self.assertIsNone(non_existent_issue)
    
    def test_update_issue(self):
        """Test updating an issue."""
        # Add an issue
        issue = self.tracker.add_issue("Test Issue", "This is a test issue")
        
        # Update the issue
        updated_issue = self.tracker.update_issue(
            issue.issue_id,
            title="Updated Title",
            description="Updated Description",
            status="closed"
        )
        
        # Check that the issue was updated
        self.assertEqual(updated_issue.title, "Updated Title")
        self.assertEqual(updated_issue.description, "Updated Description")
        self.assertEqual(updated_issue.status, "closed")
        
        # Try to update a non-existent issue
        non_existent_update = self.tracker.update_issue(
            999,
            title="This won't work"
        )
        self.assertIsNone(non_existent_update)
    
    def test_persistence(self):
        """Test that issues are saved to and loaded from the file."""
        # Add some issues
        self.tracker.add_issue("Issue 1", "Description 1")
        self.tracker.add_issue("Issue 2", "Description 2")
        
        # Create a new tracker with the same file
        new_tracker = IssueTracker(self.temp_file.name)
        
        # Check that the issues were loaded
        issues = new_tracker.list_issues()
        self.assertEqual(len(issues), 2)
        self.assertEqual(issues[0].title, "Issue 1")
        self.assertEqual(issues[1].title, "Issue 2")


if __name__ == "__main__":
    unittest.main()