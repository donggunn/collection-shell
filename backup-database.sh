#!/bin/bash

USER="root"
PASSWORD="toor"
OUTPUT=${PWD##*/}/DBs

SCRIPTSRC=`readlink -f "$0" || echo "$0"`
RUN_PATH=`dirname "${SCRIPTSRC}" || echo .`

#rm "$OUTPUTDIR/*gz" > /dev/null 2>&1
mkdir -p DBs
databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $USER -p$PASSWORD --databases $db > ${RUN_PATH}/DBs/$db.sql
       # gzip $OUTPUT/`date +%Y%m%d`.$db.sql
    fi
done
zip -r `date +%Y%m%d`.DBs.zip DBs
rm -rf DBs