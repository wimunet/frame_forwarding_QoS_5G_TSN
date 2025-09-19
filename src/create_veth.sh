#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)

echo "Creating Virtual Ethernets veth0 and veth1 ...."
sudo ip link add name veth0 type veth peer name veth1
sudo ip link set veth0 up
sudo ip link set veth1 up
