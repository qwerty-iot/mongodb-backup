################################################
##    Copyright 2020, Jim Wert                ##
################################################

if [ "${TASK}" = "restore" ]; then
# explicit restore

  if [ -z "${RESTORENAME}" ]; then
    # if no restore name is found, find the last uplaoded backup
    AZURE_BLOBS=($(az storage blob list --container-name ${AZURE_CONTAINER} --connection-string="${AZURE_CONNSTRING}" --prefix="${BACKUP_PREFIX}" --query "[].[name]" -o tsv))
	RESTORENAME=${AZURE_BLOBS[-1]}
	echo "restoring: $RESTORENAME"
  fi
	
  az storage blob download --no-progress --container-name ${AZURE_CONTAINER} -n=${RESTORENAME} -f ./restore.tar.gz --connection-string="${AZURE_CONNSTRING}"
	
  mongorestore --uri=${MONGO_URI} --authenticationMechanism=SCRAM-SHA-256 --authenticationDatabase=admin --gzip --archive="restore.tar.gz" --drop -v
else
# implied backup

  DATE=`date +%Y%m%d-%H%M`
  BACKUPNAME="${BACKUP_PREFIX}-${DATE}.tar.gz"

  mongodump --uri=${MONGO_URI} --db=${MONGO_DB} --authenticationMechanism=SCRAM-SHA-256 --authenticationDatabase=admin --readPreference=primary --gzip --archive="backup.tar.gz"
  RC=$?
  if [ "$check" -ne "0" ]; then
    echo "mongodump failed: $RC"
    exit $RC
  fi
  az storage blob upload --container-name ${AZURE_CONTAINER} -n=${BACKUPNAME} -f ./backup.tar.gz --connection-string="${AZURE_CONNSTRING}"
fi



