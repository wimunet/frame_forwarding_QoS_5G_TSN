#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# Define a queue for input traffic (compulsory tc)- Only first time


# Parametros
IFACE_INPUT=veth0

# Añadir Ifs para argumentos
while getopts ":i:" opt; do
  case ${opt} in
    i )
      IFACE_INPUT=$OPTARG
      ;;
    \? )
      echo "Uso: map_vlanpcp2vxlan_new_queue.sh [-var value]"
      echo "-i        interface input(interface where TSN traffic is introduced to 5GCore)"

      ;;
  esac
done


# Mostrar valores usados en la prueba
echo "INTERFACE_INPUT: $IFACE_INPUT"

# Map commands, tested by Oscar Adamuz on Virtual Box (this must be done in TSN Switch)
echo "sudo tc qdisc add dev $IFACE_INPUT handle ffff: ingress"
sudo tc qdisc add dev $IFACE_INPUT handle ffff: ingress
