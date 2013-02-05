#Scheduled MongoDB Backup

### Script for mongodb database backup to amazon S3.

####Required
1. Boto S3 [pip install boto]  
2. s3multiput or s3cmd comes with Amazon EC2 [apt-get install s3cmd]  
3. FileChunkIO [easy_install FileChunkIO]  



####Settings

1. Add amazon bucketname, s3 key & secret in aws_s3.py  
2. Create a cron job by crontab -e  
3. Add the following lines of code, which just send mail if the backup is done  
`0 5 * * 1 touch /home/ubuntu/db-backup/mongodb-auto-backup/backup.sh /dev/null 2>&1`

Set the backup time according to your requirement, for more read http://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/

####Credits

1. http://sunilarora.org/database-backup-from-mongodb-to-amazon-s3-and  
2. http://www.xorcode.com/2012/08/22/round-robin-mongodb-backups-to-s3-with-tar/  


PS: This is bit of a learning bash, license apache 2
