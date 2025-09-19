#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# Filter input packets in function of VLAN and PCP, then retransmite it to Vxlan (one time per duple <VLAN,PCP>)


# Parametros
IFACE_INPUT=veth0
VLAN_ID=100
PCP=0
VXLAN=vxlan1000

# Añadir Ifs para argumentos
while getopts ":i:v:p:x:" opt; do
  case ${opt} in
    i )
      IFACE_INPUT=$OPTARG
      ;;
    v )
      VLAN_ID=$OPTARG
      ;;
    p )
      PCP=$OPTARG
      ;;
    x )
      VXLAN=$OPTARG
      ;;
    \? )
      echo "Uso: map_vlanpcp2vxlan.sh [-var value]"
      echo "-i        interface input(interface where TSN traffic is introduced to 5GCore)"
      echo "-v        Vlan ID"
      echo "-p        PCP"
      echo "-x        Vxlan ID"

      ;;
  esac
done


# Mostrar valores usados en la prueba

echo "INTERFACE_INPUT: $IFACE_INPUT"
echo "VLAN_ID: $VLAN_ID"
echo "PCP: $PCP"
echo "VXLAN: $VXLAN"

# Map commands, tested by Oscar Adamuz on Virtual Box (this must be done in TSN Switch)
echo "sudo tc filter add dev $IFACE_INPUT ingress protocol 802.1Q flower vlan_id $VLAN_ID vlan_prio $PCP action mirred egress redirect dev $VXLAN "
sudo tc filter add dev $IFACE_INPUT ingress protocol 802.1Q flower vlan_id $VLAN_ID vlan_prio $PCP action mirred egress redirect dev $VXLAN

