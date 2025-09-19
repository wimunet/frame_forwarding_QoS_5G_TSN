#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# Map QoS Flow (5QI) to DSCP (one time per vxlan)


# Parametros
PORT=7000
MARK_ID=7000
DSCP=0

# Añadir Ifs para argumentos
while getopts ":p:m:d:" opt; do
  case ${opt} in
    p )
      PORT=$OPTARG
      ;;
    m )
      MARK_ID=$OPTARG
      ;;
    d )
      DSCP=$OPTARG
      ;;
    \? )
      echo "Uso: map_QoS_5QI_DSCP.sh [-var value]"
      echo "-p        port (UDP or TCP)"
      echo "-m        mark_id"
      echo "-d        DSCP"

      ;;
  esac
done


# Mostrar valores usados en la prueba

echo "PORT: $PORT"
echo "MARK_ID: $MARK_ID"
echo "DSCP: $DSCP"

# Map commands, tested by Oscar Adamuz on Virtual Box (using DSCP, maybe tested with PCP over frame on layer 2)
# Assign a port to each vxlan
echo "sudo iptables -t mangle -A POSTROUTING -p udp --dport $PORT -j MARK --set-mark $MARK_ID"
sudo iptables -t mangle -A POSTROUTING -p udp --dport $PORT -j MARK --set-mark $MARK_ID


# Assign a vxlan to an ethernet frame with a specific vlan_id and pcp
echo "sudo iptables -t mangle -A POSTROUTING -m mark --mark $MARK_ID -j DSCP --set-dscp $DSCP"
sudo iptables -t mangle -A POSTROUTING -m mark --mark $MARK_ID -j DSCP --set-dscp $DSCP
