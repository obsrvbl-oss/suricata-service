from __future__ import print_function

import os
import yaml

SURICATA_CONFIG_PATH = '/opt/suricata/suricata.yaml'

# Load the current configuration
with open(SURICATA_CONFIG_PATH, 'rt') as infile:
    config = yaml.load(infile)

# Set the interfaces
env_ifaces = os.getenv('OBSRVBL_PNA_IFACES')
if env_ifaces:
    all_ifaces = sorted(env_ifaces.split())
else:
    all_ifaces = sorted(os.listdir('/sys/class/net/'))

config['af-packet'] = []
for i, iface in enumerate(all_ifaces):
    if iface.startswith('lo'):
        continue
    settings = {
        'cluster-id': 99 - i,
        'cluster-type': 'cluster_flow',
        'defrag': True,
        'interface': iface,
        'threads': 1,
        'use-mmap': True,
    }
    config['af-packet'].append(settings)

# Set the home networks
env_networks = os.getenv('OBSRVBL_NETWORKS')
if env_networks:
    all_networks = '[{}]'.format(','.join(env_networks.split()))
    config['vars']['address-groups']['HOME_NET'] = all_networks

with open(SURICATA_CONFIG_PATH, 'wt') as outfile:
    print('%YAML 1.1', file=outfile)
    print('---', file=outfile)
    yaml.dump(config, outfile, default_flow_style=False)
