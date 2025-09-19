#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# UE<-->IP + Multicast group for UEs in same vlan


# Parametros
VXLAN_NAME="vxlan1000"
VXLAN_ID=1000
IFACE_PHY="tun2"
IP_MULTICAST=239.1.1.1
DPORT=7000
MAC_ADDRESS="10:10:10:10:10:01"


# Añadir Ifs para argumentos
while getopts ":x:v:i:m:p:a:" opt; do
  case ${opt} in
    x )
      VXLAN_NAME=$OPTARG
      ;;
    v )
      VXLAN_ID=$OPTARG
      ;;
    i )
      IFACE_PHY=$OPTARG
      ;;
    m )
      IP_MULTICAST=$OPTARG
      ;;
    p )
      DPORT=$OPTARG
      ;;
    a )
      MAC_ADDRESS=$OPTARG
      ;;
    \? )
      echo "Uso: conf_vxlan_multicast.sh [-var value]"
      echo "-x        vxlan_name"
      echo "-v        vxlan_id"
      echo "-i        physical interface"
      echo "-m        ip mulsticast"
      echo "-p        dest. port"
      echo "-a        mac address"

      ;;
  esac
done


# Mostrar valores usados en la prueba

echo "VXLAN_NAME: $VXLAN_NAME"
echo "VXLAN_ID: $VXLAN_ID"
echo "IFACE_PHYSICAL: $IFACE_PHYSICAL"
echo "IP_MULTICAST: $IP_MULTICAST"
echo "DPORT: $DPORT"
echo "MAC_ADDRESS: $MAC_ADDRESS"

# Commands tested by Oscar Adamuz on Virtual Box
echo "sudo ip link add name $VXLAN_NAME type vxlan id $VXLAN_ID dev $IFACE_PHY group $IP_MULTICAST dstport $DPORT"
echo "sudo ip link set dev $VXLAN_NAME address $MAC_ADDRESS"
echo "sudo ip link set $VXLAN_NAME  up"

sudo ip link add name $VXLAN_NAME type vxlan id $VXLAN_ID dev $IFACE_PHY group $IP_MULTICAST dstport $DPORT
sudo ip link set dev $VXLAN_NAME address $MAC_ADDRESS
sudo ip link set $VXLAN_NAME  up

