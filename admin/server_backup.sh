#!/bin/bash
#################################################################
#
# Backup files or directories to a specified location
#
#################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
# Full name of the weekday followed by full name of the month
# and day of the month separated by a hyphen.
today=$(date "+%A, %B-%d, %Y")
HOSTNAME=$(hostname -s)

################## Update below values  ########################
# Something like "/home /var/spool/mail /etc /root /boot /opt"
BACKUP_FILES="/path/to/backup"
# Something like "/mnt/backup"
BACKUP_PATH="/path/to/destination"

#################################################################

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if ! mkdir -p ${BACKUP_PATH}/"${today}"
then
	err "Cannot create backup directory in ${BACKUP_PATH}/${today}.
	Go and fix it!" 1>&2
	exit 1;
fi;

# Print start status message
echo "Back up started for ${HOSTNAME}"
date
echo

# Backup the files using tar
if ! tar -czf ${BACKUP_PATH}/"${today}"/"${HOSTNAME}" ${BACKUP_FILES}
then
  err "Backup failed"
else
  echo "Backup done"
  # Listing of files in backup destination
  ls -lh "${DATABASE_BACKUP_PATH}"/"${today}"
fi

### End of script ####
