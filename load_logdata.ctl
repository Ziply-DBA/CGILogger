load data into table overdrive.load_logdata
insert
fields terminated by "|"
trailing nullcols
(
username,
hostname,
log_date,
routing_key,
status,
details
)
