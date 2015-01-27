import boto
s3 = boto.connect_s3()
bucket = s3.get_bucket('dcsc')
key = bucket.get_key('silene.sql')
key.get_contents_to_filename('silene.sql')
