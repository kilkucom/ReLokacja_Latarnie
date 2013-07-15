#!/bin/bash

tekst_query=$1
query_do_sqlite=$(echo "$tekst_query" | sed 's/^/'\'/g | sed 's/|/'\''|'/g | sed 's/|$//'g | sed 's/|/ OR klucze=/'g | sed 's/=/='\'/g | sed 's/^/klucze=/g')
# echo $query_do_sqlite
sqlite3 ./dopasowania.db "SELECT akcja FROM dopasowania WHERE $query_do_sqlite"
