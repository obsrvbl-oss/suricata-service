#!/bin/sh
set -x

BINARY_PATH=/usr/bin/suricata
SURICATA_DIR=/opt/suricata

# Create a suricata system user and group with the given home directory
mkdir -p $SURICATA_DIR

adduser \
    --quiet \
    --system \
    --no-create-home \
    --group \
    --disabled-password \
    --home $SURICATA_DIR \
    suricata

# If the ona-service package (recommended) is installed, add the obsrvbl_ona
# user to the suricata group so it can read alert logs.
addgroup obsrvbl_ona suricata

# Create locations for rules, logs, and templates
mkdir -p $SURICATA_DIR/rules
mkdir -p $SURICATA_DIR/logs
cp /etc/nsm/templates/suricata/*.config $SURICATA_DIR

# Set permissions
chown -R suricata:suricata $SURICATA_DIR
chown suricata:suricata $BINARY_PATH
chmod 0750 $BINARY_PATH
chmod 0754 $SURICATA_DIR/manage.sh
chmod g+w $SURICATA_DIR/logs
setcap cap_net_raw,cap_net_admin=eip $BINARY_PATH
