#! /bin/bash

mysql -uroot -p123123 -t <<EDF
    
source   src/step1/query1.sql 

EDF