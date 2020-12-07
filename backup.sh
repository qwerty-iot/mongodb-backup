################################################
##    Copyright 2020, Jim Wert                ##
################################################

DATE=`date +%Y%m%d-%H%M`
BACKUPNAME="${BACKUP_PREFIX}-${DATE}.tar.gz"

mongodump --uri=${MONGO_URI} --db=${MONGO_DB} --authenticationDatabase=admin --readPreference=secondary --gzip --archive="backup.tar.gz"

az storage blob upload --container-name ${AZURE_CONTAINER} -n=${BACKUPNAME} -f ./backup.tar.gz --connection-string="${AZURE_CONNSTRING}"