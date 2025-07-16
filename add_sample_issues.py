#!/usr/bin/env python3
"""
Add sample issues to the issue tracker.
"""

from issue_tracker import IssueTracker

def main():
    """Add sample issues to the issue tracker."""
    tracker = IssueTracker()
    
    # Add some sample issues
    issue1 = tracker.add_issue(
        "Fix login page layout",
        "The login page layout is broken on mobile devices."
    )
    print(f"Added {issue1}")
    
    issue2 = tracker.add_issue(
        "Implement user registration",
        "Create a user registration form with email verification."
    )
    print(f"Added {issue2}")
    
    issue3 = tracker.add_issue(
        "Update documentation",
        "Update the API documentation with the new endpoints."
    )
    print(f"Added {issue3}")
    
    # Update some issues
    tracker.update_issue(issue1.issue_id, status="in progress")
    print(f"Updated {issue1.issue_id} status to 'in progress'")
    
    tracker.update_issue(issue2.issue_id, status="closed")
    print(f"Updated {issue2.issue_id} status to 'closed'")
    
    print("\nAll issues added successfully. Run './issue_tracker list' to see them.")

if __name__ == "__main__":
    main()