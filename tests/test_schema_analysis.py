import unittest
import os
import subprocess
import sys

class TestSchemaAnalysis(unittest.TestCase):
    """Test the database schema analysis script"""
    
    def setUp(self):
        # Make sure the script is executable
        os.system("chmod +x /workspace/analyze_db_schema.sh")
    
    def test_script_runs_without_error(self):
        """Test that the script runs without errors"""
        result = subprocess.run(["/workspace/analyze_db_schema.sh"], 
                               stdout=subprocess.PIPE, 
                               stderr=subprocess.PIPE,
                               cwd="/workspace")
        
        # Check that the script executed successfully
        self.assertEqual(result.returncode, 0, f"Script failed with error: {result.stderr.decode('utf-8')}")
        
        # Check that the output contains expected sections
        output = result.stdout.decode('utf-8')
        self.assertIn("DATABASE SCHEMA ANALYSIS", output)
        self.assertIn("TABLE SCHEMAS", output)
        self.assertIn("RELATIONSHIPS", output)
        self.assertIn("ENTITY RELATIONSHIP DIAGRAM", output)
        self.assertIn("SUMMARY", output)
    
    def test_identifies_all_tables(self):
        """Test that the script identifies all expected tables"""
        result = subprocess.run(["/workspace/analyze_db_schema.sh"], 
                               stdout=subprocess.PIPE, 
                               stderr=subprocess.PIPE,
                               cwd="/workspace")
        
        output = result.stdout.decode('utf-8')
        
        # Check for all expected tables
        expected_tables = ["users", "products", "categories", "orders", "order_items"]
        for table in expected_tables:
            self.assertIn(table, output, f"Table '{table}' not found in analysis output")
    
    def test_identifies_relationships(self):
        """Test that the script identifies relationships between tables"""
        result = subprocess.run(["/workspace/analyze_db_schema.sh"], 
                               stdout=subprocess.PIPE, 
                               stderr=subprocess.PIPE,
                               cwd="/workspace")
        
        output = result.stdout.decode('utf-8')
        
        # Check for relationship identifications
        self.assertIn("Relates to: User", output)
        self.assertIn("Relates to: Product", output)
        self.assertIn("Relates to: Order", output)
        self.assertIn("Relates to: Category", output)

if __name__ == "__main__":
    unittest.main()