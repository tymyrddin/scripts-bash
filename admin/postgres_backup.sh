#!/bin/bash
#################################################################
#
# Backup a MySQL database and compress the backup file
# https://www.postgresql.org/docs/current/app-pgdump.html
#
#################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
# Full name of the weekday followed by full name of the month
# and day of the month separated by a hyphen.
today=$(date "+%A, %B-%d, %Y")

################## Update below values  #########################

DATABASE_BACKUP_PATH='/path/to/destination'
DATABASE_HOST='localhost'
DATABASE_PORT='3306'
DATABASE_USER='root'
DATABASE_NAME='mydb'

#################################################################

sqlfile=${DATABASE_BACKUP_PATH}/"${today}"/${DATABASE_NAME}-"${today}".sql
zipfile=${DATABASE_BACKUP_PATH}/"${today}"/${DATABASE_NAME}-"${today}".zip

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
today
echo

# if ! pg_dump -d postgresql://${DATABASE_USER}:${DATABASE_PASSWORD}@${DATABASE_HOST}:
# ${DATABASE_PORT}/${DATABASE_NAME} > "$sqlfile"

# -W Forces pg_dump to prompt for a password before connecting to a database.
# Or create a .pgpass file containing only (and set its mode to 0600):
# hostname:port:database:username:password

if ! pg_dump -h ${DATABASE_HOST} \
		  -U ${DATABASE_USER} \
		  -W ${DATABASE_NAME} \
		  -p ${DATABASE_PORT} > "$sqlfile"
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
