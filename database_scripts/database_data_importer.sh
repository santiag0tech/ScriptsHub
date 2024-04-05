#!/bin/bash
# Database Connectivity
DB_NAME=""
DB_USER=""
DB_TABLE_NAME=""
# Path CSV File
CSV_FILE=""

# Command to import the CSV file to the MYSQL table
mysql --local_infile=1 -u "$DB_USER" -p <<EOF
set global local_infile=true;
use $DB_NAME;
LOAD DATA LOCAL INFILE '$CSV_FILE'
INTO TABLE $DB_TABLE_NAME
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
set global local_infile=false;
EOF
