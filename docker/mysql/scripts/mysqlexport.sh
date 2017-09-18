#!/bin/sh
# Export Magento Database

# check if Database exists
echo -n "> Checking if database exists ... "
db_exists=$(mysql --batch --skip-column-names -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "SHOW DATABASES LIKE '"$MYSQL_DATABASE"';" | grep "$MYSQL_DATABASE" > /dev/null; echo "$?")
if [ ! $db_exists -eq 0 ]; then
    echo "database does not exist!"
    echo -e "\n"
    exit 1
fi
echo "OK"

# all okay ... proceed with import
echo -n "> Exporting database ............ "
now=$(date +"%Y-%m-%d_%H-%M-%S")
mysqldump --opt --single-transaction -u $MYSQL_USER -p"$MYSQL_PASSWORD" $MYSQL_DATABASE | gzip > /mysqldumps/$MYSQL_DATABASE_$now.sql.gz
chown mysql:mysql /mysqldumps/*
echo "DONE!"

echo -e "\n"