#!/bin/sh

# Load the Observable configuration if it exists
if [ -e /opt/obsrvbl-ona/config ]; then
    . /opt/obsrvbl-ona/config
fi

# Update the Suricata configuration file
/usr/bin/python2.7 /opt/suricata/iface_config.py

# Run suricata
exec /usr/bin/sudo -u suricata \
    /usr/bin/suricata \
        -c /opt/suricata/suricata.yaml \
        --af-packet
