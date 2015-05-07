#!/bin/sh
mkdir -p /opt/suricata
adduser \
--quiet \
--system \
--no-create-home \
--group \
--disabled-password \
--home /opt/suricata \
suricata

mkdir -p /opt/suricata/logs
cp /etc/nsm/templates/suricata/* /opt/suricata
chown -R suricata /opt/suricata

SURICATA=/usr/bin/suricata
chown suricata $SURICATA
chmod 750 $SURICATA
setcap cap_net_raw,cap_net_admin=eip $SURICATA
