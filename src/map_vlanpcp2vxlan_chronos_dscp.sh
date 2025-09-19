#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# Mapea la tupla <VLAN_ID,PCP> a <VXLAN>

sudo ~/src/map_vlanpcp2vxlan_new_queue.sh -i veth0
sudo ~/src/map_vlanpcp2vxlan_filter.sh -i veth0 -p 0 -x vxlan1000
#sudo ~/src/map_vlanpcp2vxlan_filter.sh -i veth0 -p 2 -x vxlan1002
sudo ~/src/map_vlanpcp2vxlan_filter.sh -i veth0 -p 5 -x vxlan1005
sudo ~/src/map_vlanpcp2vxlan_filter.sh -i veth0 -p 7 -x vxlan1007
