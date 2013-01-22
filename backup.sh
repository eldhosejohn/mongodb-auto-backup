
#!/bin/bash

MONGODB_SHELL='' #otherwise location
DUMP_UTILITY=''
DB_NAME=''

USERNAME=""
PASSWORD=""
 
SCRIPT_DIR="/home/ubuntu/db-backup/mongodb-auto-backup"

date_now=`date +%Y_%m_%d_%H_%M_%S`
#dir_name='db_backup_'${date_now}
#file_name='db_backup_'${date_now}'.bz2'


BACKUP_DIR_NAME=${SCRIPT_DIR}'/db_backup_'${date_now}
BACKUP_FILE_NAME='db_backup_'${date_now}'.bz2'
BACKUP_FILE_LOCN=${SCRIPT_DIR}'/'${BACKUP_FILE_NAME}

FSYNC_FILE=${SCRIPT_DIR}'/fsync_lock.js'   #The MongoDB Lock file to avoid data writes
UNLCK_FILE=${SCRIPT_DIR}'/unlock.js'  #The MongoDB unlock file
S3_FILE=${SCRIPT_DIR}'/aws_s3.py'  #Python script to pload to S3
 
log() {
    echo $1
}
 
do_cleanup(){
   # rm -r  ${BACKUP_DIR_NAME}
   # rm ${BACKUP_FILE_LOCN}    
    log 'cleaning up....'
}
 
do_backup(){
    log 'snapshotting the db and creating archive' && \
    ${MONGODB_SHELL} admin ${FSYNC_FILE} && \
    ${DUMP_UTILITY} -d ${DB_NAME} -u ${USERNAME} -p ${PASSWORD} -o ${BACKUP_DIR_NAME} && tar jcfP ${BACKUP_FILE_LOCN} ${BACKUP_DIR_NAME}
    ${MONGODB_SHELL} admin ${UNLCK_FILE} && \
    log 'data backd up and created snapshot'
}
 
save_in_s3(){
    log 'saving the backup archive in amazon S3' && \
    python ${S3_FILE} set ${BACKUP_FILE_NAME} ${BACKUP_FILE_LOCN} && \
    log 'data backup saved in amazon s3'
}
 
do_backup && save_in_s3 && do_cleanup
