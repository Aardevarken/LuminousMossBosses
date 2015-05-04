"""
File: run_tests.py
Written by: Brian Bauer
About: Running all application tests 
"""

from test.messages import *
from test.general_tests import *
from test.app_tests import AppTestCase
import unittest

def main():
    tryMessage(modelTableTest('DetectionObject'))
    tryMessage(modelTableTest('Observation'))
    tryMessage(modelTableTest('User'))
    tryMessage(modelTableTest('Device'))
    tryMessage(modelTableTest('TestResult'))
    tryMessage(modelTableTest('XMLData'))
    unittest.main()

if __name__ == '__main__':
    main()  
