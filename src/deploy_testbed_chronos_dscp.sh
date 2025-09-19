#/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)

# Asume that link 5G is established by DNN Internet (NET 192.168.3.x/24)



# Create Virtual Ethernet 
sudo ~/src/create_veth.sh

#Configuración Vxlan 1000 (VLAN 100 PCP 0-Default) - Low Prio
sudo ~/src/conf_vxlan_multicast.sh -x vxlan1000 -v 1000 -i tun2 -m 239.1.1.1 -p 7000 -a 10:10:10:10:10:01 #Cambiar Interfaz a tun2 
sudo ~/src/add_virtualbridge.sh -v vbr0 -i 10.10.10.1/24 -m 20:20:20:20:20:01 -x vxlan1000
sudo ~/src/map_QoS_5QI_DSCP.sh -p 7000 -m 7000 -d 0 # DSCP 0

#Configuración Vxlan 1002 (VLAN 100 PCP 2) - Mid-Low Prio
#sudo ~/src/conf_vxlan_multicast.sh -x vxlan1002 -v 1002 -i tun2 -m 239.1.1.2 -p 7002 -a a2:a2:a2:a2:a2:01 
#sudo ~/src/add_virtualbridge.sh -v vbr2 -i 10.10.20.1/24 -m 2a:2a:2a:2a:2a:01 -x vxlan1002
#sudo ~/src/map_QoS_5QI_DSCP.sh  -p 7002 -m 7002 -d 16 # DSCP 16

# Configuración Vxlan 1005 (VLAN 100 PCP 5) - Mid-High Prio
sudo ~/src/conf_vxlan_multicast.sh -x vxlan1005 -v 1005 -i tun2 -m 239.1.1.2 -p 7005 -a 12:12:12:12:12:01
sudo ~/src/add_virtualbridge.sh -v vbr5 -i 10.10.20.1/24 -m 22:22:22:22:22:01 -x vxlan1005
sudo ~/src/map_QoS_5QI_DSCP.sh  -p 7005 -m 7005 -d 40 # DSCP 40


# Configuración Vxlan 1007 (Vlan 100 PCP 7) - High Prio
sudo ~/src/conf_vxlan_multicast.sh -x vxlan1007 -v 1007 -i tun2 -m 239.1.1.3 -p 7007 -a a2:a2:a2:a2:a2:01
sudo ~/src/add_virtualbridge.sh -v vbr7 -i 10.10.30.1/24 -m 2a:2a:2a:2a:2a:01 -x vxlan1007
sudo ~/src/map_QoS_5QI_DSCP.sh  -p 7007 -m 7007 -d 56 # DSCP 56


#Filter Traffic Control
sudo ~/src/map_vlanpcp2vxlan_chronos_dscp.sh




