ACCESS_KEY=''
SECRET=''
BUCKET_NAME='' #note that you need to create this bucket first
 
from boto.s3.connection import S3Connection
from boto.s3.key import Key
 
def save_file_in_s3(filename, filelocation):
    conn = S3Connection(ACCESS_KEY, SECRET)
    bucket = conn.get_bucket(BUCKET_NAME)
    k = Key(bucket)
    k.key = filename
    k.set_contents_from_filename(filelocation)
 
def get_file_from_s3(filename):
    conn = S3Connection(ACCESS_KEY, SECRET)
    bucket = conn.get_bucket(BUCKET_NAME)
    k = Key(bucket)
    k.key = filename
    k.get_contents_to_filename(filename)
 
def list_backup_in_s3():
    conn = S3Connection(ACCESS_KEY, SECRET)
    bucket = conn.get_bucket(BUCKET_NAME)
    for i, key in enumerate(bucket.get_all_keys()):
        print "[%s] %s" % (i, key.name)
 
def delete_all_backups():
    #FIXME: validate filename exists
    conn = S3Connection(ACCESS_KEY, SECRET)
    bucket = conn.get_bucket(BUCKET_NAME)
    for i, key in enumerate(bucket.get_all_keys()):
        print "deleting %s" % (key.name)
        key.delete()
 
if __name__ == '__main__':
    import sys
    if len(sys.argv) < 3:
        print 'Usage: %s <get/set/list/delete> <backup_filename>' % (sys.argv[0])
    else:
        if sys.argv[1] == 'set':
            save_file_in_s3(sys.argv[2], sys.argv[3])
        elif sys.argv[1] == 'get':
            get_file_from_s3(sys.argv[2])
        elif sys.argv[1] == 'list':
            list_backup_in_s3()
        elif sys.argv[1] == 'delete':
            delete_all_backups()
        else:
            print 'Usage: %s <get/set/list/delete> <backup_filename>' % (sys.argv[0])

