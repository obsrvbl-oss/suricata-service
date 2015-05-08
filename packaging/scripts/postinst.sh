#!/bin/sh
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

# Create locations for rules, logs, and templates
mkdir -p $SURICATA_DIR/rules
mkdir -p $SURICATA_DIR/logs
cp /etc/nsm/templates/suricata/*.config $SURICATA_DIR

# Set permissions
chown -R suricata:suricata $SURICATA_DIR
chown suricata:suricata $BINARY_PATH
chmod 750 $BINARY_PATH
setcap cap_net_raw,cap_net_admin=eip $BINARY_PATH
