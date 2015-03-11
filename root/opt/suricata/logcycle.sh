#!/bin/bash

# run every ten minutes.

DATE=$(date +%s)
PID=$(ps ax | grep "suricata -c suricata.yaml" | grep -v grep | awk '{print $1}')

cd logs
mv eve.json eve.json.$DATE

# sending a HUP to suricata tells it to re-open its log files
/bin/kill -HUP $PID

# TODO:
# do something with the eve.json.$DATE file

rm eve.json.$DATE

