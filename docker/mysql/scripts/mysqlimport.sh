#!/bin/sh
# Import Magento Database
# EXPECTS: /mysqldumps/dbimport.sql.gz

# check if import file exists
echo -n "> Looking for import file ...... "
if [ ! -f "/mysqldumps/dbimport.sql.gz" ]; then
    echo "expected file (/mysqldumps/dbimport.sql.gz) does not exist!"
    echo -e "\n"
    exit 1
fi
echo "OK"

# check if Database exists
echo -n "> Checking database exists ..... "
db_exists=$(mysql --batch --skip-column-names -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "SHOW DATABASES LIKE '"$MYSQL_DATABASE"';" | grep "$MYSQL_DATABASE" > /dev/null; echo "$?")
if [ ! $db_exists -eq 0 ]; then
    echo "database does not exist!"
    echo -e "\n"
    exit 1
fi
echo "OK"

# check if db contains no tables before import
echo -n "> Checking database is empty ... "
tables_exist=$(mysql -u $MYSQL_USER -p"$MYSQL_PASSWORD" -s --skip-column-names -e "SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema = '$MYSQL_DATABASE'")
if [ ! $tables_exist -eq 0 ]; then
    echo "no, database contains tables!"
    echo -e "\n"
    exit 1
fi
echo "OK"

# all okay ... proceed with import
echo -n "> Importing database ........... "
gunzip /mysqldumps/dbimport.sql.gz
mysql -u $MYSQL_USER -p"$MYSQL_PASSWORD" $MYSQL_DATABASE < /mysqldumps/dbimport.sql
rm /mysqldumps/dbimport.sql
echo "DONE!"

echo -e "\n"