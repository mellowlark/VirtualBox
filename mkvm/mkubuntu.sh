#!/bin/bash
if [ ! $1 ]; then
echo argument required
exit
fi

MACHINENAME=$1
BASE=/opt/VirtualBoxVMs
DVD=ISOs/ubuntu-24.04-live-server-amd64.iso
#Create VM
VBoxManage createvm --name $MACHINENAME --ostype "linux_64" --register --basefolder $BASE
#Set memory and network
VBoxManage modifyvm $MACHINENAME --ioapic on
VBoxManage modifyvm $MACHINENAME --memory 1024 --vram 128
VBoxManage modifyvm $MACHINENAME --nic1 nat --nat-network1 natnetwork22
#Create Disk and connect Iso
VBoxManage createhd --filename ${BASE}/$MACHINENAME/${MACHINENAME}_disk.vdi --size 25000 --variant Standard --format VDI
VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  ${BASE}/$MACHINENAME/${MACHINENAME}_disk.vdi
VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ${BASE}/${DVD}
VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
#Enable RDP
VBoxManage modifyvm $MACHINENAME --vrde on --vrde-port 13389
#Start the VM
VBoxManage startvm $MACHINENAME --type headless

