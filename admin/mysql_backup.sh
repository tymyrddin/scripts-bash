#!/bin/bash
#################################################################
#
# Backup a MySQL database and compress the backup file
# https://dev.mysql.com/doc/refman/8.4/en/mysqldump.html
#
#################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
# Full name of the weekday followed by full name of the month
# and day of the month separated by a hyphen.
today=$(date "+%A, %B-%d, %Y")

################## Update below values  ########################

DATABASE_BACKUP_PATH='/path/to/destination'
DATABASE_HOST='localhost'
DATABASE_PORT='3306'
DATABASE_USER='root'
DATABASE_NAME='mydb'

#################################################################

sqlfile=${DATABASE_BACKUP_PATH}/"${today}"/${DATABASE_NAME}-"${today}".sql
zipfile=${DATABASE_BACKUP_PATH}/"${today}"/${DATABASE_NAME}-"${today}".sql.gz

err() {
  echo "[${today}]: $*" >&2
}

if ! mkdir -p ${DATABASE_BACKUP_PATH}/"${today}"
then
	err "Cannot create backup directory in ${DATABASE_BACKUP_PATH}/${today}.
	Go and fix it!" 1>&2
	exit 1;
fi;

echo "Backup started for database ${DATABASE_NAME}"
date
echo

# Create a mysqlpassword.cnf containing (only):
#
#[mysqldump]
#password="ThisIsThePassword"
if ! mysqldump --defaults-extra-file=/etc/mysql/mysqlpassword.cnf \
      -h ${DATABASE_HOST} \
		  -P ${DATABASE_PORT} \
		  -u ${DATABASE_USER} \
		  ${DATABASE_NAME} > "$sqlfile"
then
  err "Dump failed"
  exit 1
else
  if ! gzip -c "${sqlfile}" > "${zipfile}"
  then
    err "Compression failed"
    exit 1
  else
    echo "Backup done:"
    # Listing of files in backup destination
    ls -lh ${DATABASE_BACKUP_PATH}/"${today}"
    rm "$sqlfile"
  fi
fi

### End of script ####
