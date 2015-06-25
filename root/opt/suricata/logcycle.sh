#!/bin/sh

LOG_FILE=/opt/suricata/logs/eve.json
DATE=$(date +%s)
PID=$(pidof "/usr/bin/suricata")

# Exit early if the log file doesn't exist
if [ ! -e $LOG_FILE ]
then
    echo "$LOG_FILE does not exist"
    exit 0
fi

# Also exit early if the log file is 0 bytes
if [ ! -s $LOG_FILE ]
then
    echo "$LOG_FILE is 0 bytes"
    exit 0
fi


# Rename the current log file and then send suricata a HUP signal to tell it
# to open a new log file.
mv $LOG_FILE $LOG_FILE.$DATE.archived
/bin/kill -HUP $PID
