"""
File: messages.py
Written by: Brian Bauer
About: How to interface with each tests and display results in the terminal
"""

class terminalColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def tryMessage(test):
    print terminalColors.HEADER + "Running Test: " + terminalColors.UNDERLINE + test.message + terminalColors.ENDC
    try:
        test.run()
        print terminalColors.OKGREEN + "Success!" + terminalColors.ENDC
    except Exception,e:
        print terminalColors.FAIL + "Failed!" + str(e) + terminalColors.ENDC
    print "\n"
