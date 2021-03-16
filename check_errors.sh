#!/bin/bash
#This script is called by load_logdata.sh.
#Check the latest batch of log data for errors
#  and if the routing key for each is not in
#  the suppression list, send an alert
CMD="grep ERROR load_logdata.dat "
for SUPPRESS in `grep -v ^# suppress.txt`; do
  CMD="$CMD | grep -v $SUPPRESS "
done
eval $CMD > error.out && mailx -s "New errors logged" oss-db@ziply.com < error.out
