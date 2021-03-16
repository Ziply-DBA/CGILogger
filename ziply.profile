export LOGGER_HOST1=spfnwfbldpv01:8080
export LOGGER_AUTH_KEY=somesecretstring
logger_function() {
    GETSTRING="?username=$LOGNAME&hostname=`uname -n`&auth_key=$LOGGER_AUTH_KEY&routing_key=$1&status=$2"
    [[ -z $3 ]] || GETSTRING="$GETSTRING&details=$3"
    [[ -z $LOGGER_HOST1 ]] || wget -O logger.response -q --timeout=5 "http://$LOGGER_HOST1/cgi-bin/logger/$GETSTRING"
}
