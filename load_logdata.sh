#!/bin/bash
#Load the most recent log data in the local file
#  into the database table
. ~/.bash_profile
. ~/ziply.profile
STATUS=OK
DIRNAME=`dirname "$0"`
cd $DIRNAME
mv logger.dat load_logdata.dat; touch logger.dat
#Send unsuppressed errors via email
./check_errors.sh
#Delete old data from the staging table before loading new
sqlplus /nolog << EOF > /dev/null
conn $OVERDRIVE_CONN
delete from load_logdata;
EOF
#load new log data into staging table
sqlldr userid=$OVERDRIVE_CONN control=load_logdata.ctl data=load_logdata.dat log                                                                             =load_logdata.log
[[ $? -eq 0 ]] || STATUS=ERROR
#Process the data
sqlplus /nolog << EOF > /dev/null
conn $OVERDRIVE_CONN
update Load_logdata set hostname=ltrim(rtrim(hostname)),
username=ltrim(rtrim(username)),
routing_key=ltrim(rtrim(routing_key)),
status=ltrim(rtrim(status)) ,
details=ltrim(rtrim(details));
update load_logdata set hostname = replace(hostname,'.nw1.nwestnetwork.com','');
update load_logdata set hostname = replace(hostname,'.nwestnetwork.com','');
update load_logdata set hostname = replace(hostname,'.corp.pvt','');

insert into logdata (username , hostname, log_date, routing_key, status, details     )
select username , hostname, to_date(log_date,'YYYY-MM-DD HH24:MI:SS'), routing_key, status, details from load_logdata;
EOF
[[ $? -eq 0 ]] || STATUS=ERROR
logger_function `basename "$0"` $STATUS
