# include this file to get the arguments dictionary and send headers

# imports, enable debugging
import cgi
import cgitb
cgitb.enable()

# Headers
print "Content-Type: text/plain;charset=utf-8"
print

# arguments variable as a dictionary arguments["urlparam"] = value
arguments = cgi.FieldStorage()
