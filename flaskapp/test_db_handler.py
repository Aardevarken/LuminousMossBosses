'''
File...........test_db_handler.py
Written By.....Brian Bauer
'''
from dbhandler.database import db_session

position = 10

def main():
    testTable('DetectionObject')
    testTable('Observation')

def testTable(name):
    table = getattr(__import__("dbhandler.models", fromlist=[name]), name)
    print table.query.get(position)

'''
Code below is not suitable for testing however was a great way to help me understand SQLALchemy
def testJoin(name1, name2):
    table1 = getattr(__import__("dbhandler.models", fromlist=[name1]), name1)
    table2 = getattr(__import__("dbhandler.models", fromlist=[name2]), name2)
    print db_session().query(table1, table2.ImageID, table2.FileName).join(table2).filter(table1.IsSilene==1).offset(5).limit(5).all()
'''

if __name__ == '__main__':
    main()
