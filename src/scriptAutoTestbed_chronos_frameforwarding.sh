#!/bin/bash
# Author: Félix Delgado-Ferro (felixdelgado@ugr.es)
# This script MUST be executed with superuser privileges

#############################
# Parsing inputs parameters #
#############################

usage() {
  echo "Usage: $0 -m <mode> -a <apn>" 1>&2;
  echo ""
  echo "E.g.: $0 -m 1"
  echo "      -m <mode> ................ 0 (without map DSCP-QFI), 1 (with map DSCP-QFI)"
  echo "      -a <mode> ................ e.g. internet"
  exit 1;
}

# Default values
# MODE  0 (No filters), 1 (filters QFI1-QFI3)
APN="internet"


# Parsing input parameters
while getopts ":m:a" o; do
  case "${o}" in
    m)
      m=1
      MODE=${OPTARG}
      echo "MODE="$MODE
      ;;
    a)
      APN=${OPTARG}
      echo "APN="$APN
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${m}" ] ; then
  usage
fi


# Auxiliary variables for SSH
COMMANDNUC04="sshpass -p 5GLaboratory ssh -o \"StrictHostKeyChecking=no\" jorge@192.168.77.106"

# Path to scripts and configuration files
BS_5G_MOUNT="/home/wimunet/mount-usb.sh"
BS_5G_DEPLOY_DSCP="/home/wimunet/scripts/deploy_testbed_chronos_dscp.sh"
BS_5G_SINCRO="/home/wimunet/scripts/sincro_ntp_nuc04.sh"
BS_5G_WIRESHARK="/home/wimunet/scripts/launch_wireshark.sh"


NUC04_RESET_QUECTEL="/home/jorge/quectel/quectel-linux-main/reset_quectel.sh"
NUC04_CONNECT_QUECTEL="/home/jorge/quectel/quectel-linux-main/connect_quectel_amarisoft_chronos_dscp.sh $APN"
NUC04_CHECK_QUECTELCARD="/home/jorge/quectel/quectel-linux-main/check_quectel_card.sh"
NUC04_CHECK_CONNECTIVITY="/home/jorge/quectel/quectel-linux-main/check_5G_connectivity.sh"
NUC04_DEPLOY_DSCP="/home/jorge/scripts/deploy_testbed_chronos_dscp.sh"
NUC04_WIRESHARK="/home/jorge/scripts/launch_wireshark.sh"


# DEBUGGING
TUNIF="tun2"
REDIRECT=" 2> /dev/null"



# Starting the script
echo "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
echo "+ WiMuNet (https://wimunet.ugr.es), University of Granada 2024  +"
echo "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"

# Using (or not) DSCP-QFI
GNB_PATH=""
AMF_PATH=""
if [[ $MODE == 0 ]]; then
   echo "[INFO] Deployment without mapping DSCP-QFI"
   GNB_PATH="/root/enb/config/fdf-gnb-sa.90170.TDD.50MHz-chronos-dscp-OAH-nofilter.cfg"
   AMF_PATH="/root/mme/config/fdf-mme-ims-chronos-dscp-nofilter.cfg"
elif [[ $MODE == 1 ]]; then
   echo "[INFO] Deployment with mapping DSCP-QFI"
   GNB_PATH="/root/enb/config/fdf-gnb-sa.90170.TDD.50MHz-chronos-dscp-OAH.cfg"
   AMF_PATH="/root/mme/config/fdf-mme-ims-chronos-dscp.cfg"
fi


###########
### NUC ###
###########

# Reset Quectel card
echo "[INFO] NUC04: resetting Quectel card"
eval $COMMANDNUC04 "screen -XS quectel quit" $REDIRECT
eval $COMMANDNUC04 "sudo $NUC04_RESET_QUECTEL" $REDIRECT


#############
### BS-5G ###
#############
echo "[INFO] gNB-amf: deploying 5G network"
sudo service lte stop $REDIRECT
sudo screen -d -m -S lte_mount bash $BS_5G_MOUNT $REDIRECT

# Assign correct configuration on enB(gNB) and mme(amf)
sudo ln -sf $GNB_PATH /root/enb/config/enb.cfg
sudo ln -sf $AMF_PATH /root/mme/config/mme.cfg
sudo service lte restart $REDIRECT

# Waiting for the service (checking the presence of the tun interface)
echo "[INFO] gNB-amf: waiting for the Amarisoft platform to be restarted"
IPADDR=`ip a show $TUNIF 2> /dev/null | grep "scope global" | tr -s " " | cut -d" " -f 3`
while [[ $IPADDR == "" ]]
do
   IPADDR=`ip a show $TUNIF 2> /dev/null | grep "scope global" | tr -s " " | cut -d" " -f 3`
   sleep 5
done


###########
### NUC ###
###########

# Wait for the Quectel card to appear after reset
echo "[INFO] NUC04: waiting for the Quectel card to appear after reset"
eval $COMMANDNUC04 "$NUC04_CHECK_QUECTELCARD" $REDIRECT

sleep 5

# Attach Quectel card to the 5G network
echo "[INFO] NUC04: attaching to the 5G network"
eval $COMMANDNUC04 "screen -d -m -S quectel bash $NUC04_CONNECT_QUECTEL" $REDIRECT
eval $COMMANDNUC04 "$NUC04_CHECK_CONNECTIVITY" $REDIRECT

NUC04INTERFACE=`eval $COMMANDNUC04 "ip a | grep wwp | cut -d\" \" -f2 | cut -d\":\" -f1"`
echo "NUC_INTERFACE: $NUC04INTERFACE"



#############
### BS-5G ###
#############

# Configure Virtual Bridge and mapping
echo "[INFO] gNB-amf: Configuring Setup on 5G Base Station..."
eval "sudo $BS_5G_DEPLOY_DSCP $REDIRECT"


#############
### NUC   ###
#############

# Configure Virtual Bridge and mapping
echo "[INFO] NUC04: Configuring Setup on NUC04..."
eval $COMMANDNUC04 "sudo $NUC04_DEPLOY_DSCP" $REDIRECT




