#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# Add virtual bridge


# Parametros
VBR_NAME="vbr0"
IP=10.10.10.1/24
MAC="20:20:20:20:20:01"
VXLAN_NAME="vxlan1000"


# Añadir Ifs para argumentos
while getopts ":v:i:m:x:" opt; do
  case ${opt} in
    v )
      VBR_NAME=$OPTARG
      ;;
    i )
      IP=$OPTARG
      ;;
    m )
      MAC=$OPTARG
      ;;
    x )
      VXLAN_NAME=$OPTARG
      ;;
    \? )
      echo "Uso: add_virtualbridge.sh [-var value]"
      echo "-v        virtual bridge name"
      echo "-i        IP (with mask) e.g. 10.10.10.1/24"
      echo "-m        MAC"
      echo "-x        vxlan name"

      ;;
  esac
done


# Mostrar valores usados en la prueba

echo "VBR_NAME: $VBR_NAME"
echo "IP: $IP"
echo "MAC: $MAC"
echo "VXLAN_NAME: $VXLAN_NAME"


echo "Adding $VBR_NAME ..."
echo "sudo brctl addbr $VBR_NAME"
echo "sudo ip addr add $IP dev $VBR_NAME"
echo "sudo ip link set dev $VBR_NAME address $MAC"
echo "sudo ip link set $VBR_NAME up"
echo "sudo brctl addif $VBR_NAME $VXLAN_NAME"
sudo brctl addbr $VBR_NAME
sudo ip addr add $IP dev $VBR_NAME
sudo ip link set dev $VBR_NAME address $MAC
sudo ip link set $VBR_NAME up
sudo brctl addif $VBR_NAME $VXLAN_NAME

