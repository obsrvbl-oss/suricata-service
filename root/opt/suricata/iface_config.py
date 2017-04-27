from __future__ import print_function, unicode_literals

import io
import os

# Paths
SURICATA_DIR = '/opt/suricata/'
SURICATA_CONFIG_FILE = os.path.join(SURICATA_DIR, 'suricata.yaml')
IFACE_CONFIG_FILE = os.path.join(SURICATA_DIR, 'af-packet.yaml')
ADDRESS_CONFIG_FILE = os.path.join(SURICATA_DIR, 'address-groups.yaml')

# Interface configuration template
IFACE_CONFIG_TEMPLATE = """\
  - interface: {iface:}
    threads: 1
    cluster-id: {cluster_id:}
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
"""

ADDRESS_CONFIG_TEMPLATE = """\
    HOME_NET: "{home_net:}"
    EXTERNAL_NET: "!$HOME_NET"
    HTTP_SERVERS: "$HOME_NET"
    SMTP_SERVERS: "$HOME_NET"
    SQL_SERVERS: "$HOME_NET"
    DNS_SERVERS: "$HOME_NET"
    TELNET_SERVERS: "$HOME_NET"
    AIM_SERVERS: "$EXTERNAL_NET"
    DNP3_SERVER: "$HOME_NET"
    DNP3_CLIENT: "$HOME_NET"
    MODBUS_CLIENT: "$HOME_NET"
    MODBUS_SERVER: "$HOME_NET"
    ENIP_CLIENT: "$HOME_NET"
    ENIP_SERVER: "$HOME_NET"
"""


# Set the interfaces
env_ifaces = os.getenv('OBSRVBL_PNA_IFACES')
if env_ifaces:
    all_ifaces = sorted(env_ifaces.split())
else:
    all_ifaces = sorted(os.listdir('/sys/class/net/'))

with io.open(IFACE_CONFIG_FILE, 'wt') as outfile:
    print('%YAML 1.1', file=outfile)
    print('---', file=outfile)
    print('af-packet:', file=outfile)

    for i, iface in enumerate(all_ifaces):
        if iface.startswith('lo'):
            continue
        iface_config = IFACE_CONFIG_TEMPLATE.format(
            iface=iface,
            cluster_id=99 - i,
        )
        print(iface_config, file=outfile)

# Set the home networks
env_networks = os.getenv(
    'OBSRVBL_NETWORKS', '10.0.0.0/8 172.16.0.0/12 192.168.0.0/16'
)
home_net = '[{}]'.format(','.join(env_networks.split()))

with io.open(ADDRESS_CONFIG_FILE, 'wt') as outfile:
    print('%YAML 1.1', file=outfile)
    print('---', file=outfile)
    address_config = ADDRESS_CONFIG_TEMPLATE.format(home_net=home_net)
    print(address_config, file=outfile)
