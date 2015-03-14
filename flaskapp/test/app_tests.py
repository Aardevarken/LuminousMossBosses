"""
File: app_tests.py
Written by: Brian Bauer
About: Where all flask unit tests go
"""

import app
import os, unittest, tempfile

class AppTestCase(unittest.TestCase):
    def setUp(self):
        app.app.config['TESTING'] = True
        self.app = app.app.test_client()
        #app.init_db()
    
    def tearDown(self):
        pass

    def login(self, username, password):
        return self.app.post('/login', data=dict(
            username=username,
            password=password
            ), follow_redirects=True)

    def logout(self):
        return self.app.get('/logout', follow_redirects=True)

    def test_login_logout(self):
        rv = self.login('admin', 'bunny')
        assert 'Invalid password' in rv.data
        rv = self.login('fadmin', 'password')
        assert 'Invalid username' in rv.data


