# Frame Forwarding and QoS treatment solution for a 5G-TSN-based industrial network
Our solution allows Ethernet frame forwarding among interconnected TSN islands (e.g., production lines and edge rooms) via an IP-based 5G system. Furthermore, our solution addresses the harmonization of QoS treatment between 5G and TSN. It is based on VxLAN tunneling to encapsulate Ethernet frames within the 5G system, ensuring that Ethernet header information is preserved as the frames traverse the 5G network. 

This repository includes details about the configurations used for the paper: 

[1] O. Adamuz-Hinojosa, F. Delgado-Ferro, J. Navarro-Ortiz, P. Muñoz, P. Ameigeiras "Unleashing 5G Seamless Integration with TSN for Industry 5.0: Frame Forwarding and QoS Treatment," IEEE Open Journal of the Communications Society, vol. 6, pp. 4874-4884, May 2025, DOI: 10.1109/OJCOMS.2025.3574397

Post-print Available: https://arxiv.org/abs/2505.20239

IEEE Xplore: https://ieeexplore.ieee.org/abstract/document/11016774

__If you use code from these repositories, please cite our paper. Thanks!__

## Setup
The setup, which validates our frame forwarding and QoS treatment solution, comprises seven devices. __5G Amarisoft__ is a general-purpose computer equipped with a PCIe SDR50 card and runs the Amarisoft software to provide a standalone 5G network. The setup also includes two UEs, each consisting of an __Intel NUC BXNUC10I7FNH2__ with a __Quectel RM500Q-GL__ card. Since the 5G system works in licensed bands, it is enclosed in an RF Shielded Test Enclosure, specifically the __Labifix LBX500__ model. And, __SecureSync 2400__ time synchronization server distributes time using the Network Time Protocol (NTP) to ensure time synchronization across devices. 

![image](https://github.com/user-attachments/assets/8b462067-eae5-4b38-9d80-25efca7b23e8)

Considering that connectivity between 5G Amarisoft and UEs has been established. It briefly explains the commands necessary to launch on each piece of equipment to deploy our solution. The code is located in their corresponding folders inside ```setup```. __Please note that this folder is currently hidden and will be made public once the paper related to this research is accepted__.

The code to deploy the setup on the __5G Amarisoft__ side is available at ```Amarisoft```. Just launch ```sudo ./deploy_testbed_chronos_dscp.sh``` and, automatically, the *veth* and *vxlan* interfaces and the virtual bridges *vbr* will be created and their relationships will be established as well. This script had been configured to forward traffic as PCP 0 (UFTP), PCP 2 (UDP), PCP 5 (PROFINET) and PCP 7 (PTPv2).  

The code to deploy the setup on the __UEs__ side is available at ```UE1``` and ```UE2```. Just launch ```sudo ./deploy_testbed_chronos_dscp.sh```. __UE1__ had been configured to PCP 0 (UFTP), PCP 5 (PROFINET) and PCP 7 (PTPv2); and __UE2__ had been configured to PCP 2 (UDP) and PCP 7 (PTPv2).

__Note 1__: Must be launched as root.

__Note 2__: This script is used as main and other bash scripts are launched. Only the main script should be modified. 

__Note 3__: This script is configured according to our proposal of traffic types for each UE. It should be modified depending on this factor.

__Note 4__: Modify the interfaces!

## Results
To validate the proposed solution, we use the [packETH tool](https://github.com/jemcek/packETH) to insert these frames (see folder ```Results/Traffic/```) into our network. After that, we captured Wireshark traces from the described traffic flows, and these captures are saved on ```Results```. These results have been split into:

- _Experiment 1_: In experiment 1, where we tested multicast forwarding, what we want to show is that our 5G system with the use of VxLAN can transmit a multicast frame to different production lines (i.e., UEs). Here, a single generated frame entering the 5G system can be transmitted to several production lines. We use PTP protocol frames as multicast frames.
- _Experiment 2_: In experiment 2, it is shown that the frames are mapped to different QoS flows in the 5G system and these are translated into a prioritized treatment of each of the 5G flows. In addition, complying with the Packet Delay Budget (PDB).



