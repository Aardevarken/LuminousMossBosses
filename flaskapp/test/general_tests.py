"""
File: general_tests.py
Written by: Brian Bauer
About: Testing flask applications
"""

class modelTableTest:
    def __init__(self, name):
        self.name = name
        self.message = "Access to table " + name

    def run(self):
        from dbhandler.database import db_session
        table = getattr(__import__("dbhandler.models", fromlist=[self.name]), self.name)
        print table.query.first()
