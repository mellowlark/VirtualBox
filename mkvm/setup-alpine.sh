# 1. Setup the Repositories 📗
_repos="
#/media/cdrom/apks
http://dl-cdn.alpinelinux.org/alpine/v3.20/main
http://dl-cdn.alpinelinux.org/alpine/v3.20/community
#http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing"

echo -e "$_repos" > /etc/apk/repositories

# 2. Node Setup
#  Add kernel module for networking stuff
echo "br_netfilter" > /etc/modules-load.d/k8s.conf
modprobe br_netfilter
sysctl net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

#  Kernel stuff
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl net.bridge.bridge-nf-call-iptables=1

#  Install kubernetes packages
apk add cni-plugin-flannel
apk add cni-plugins
apk add flannel
apk add flannel-contrib-cni
apk add kubelet
apk add kubeadm
apk add kubectl
apk add containerd
apk add uuidgen
apk add nfs-utils

#  Get rid of swap
cp -av /etc/fstab /etc/fstab.bak
sed -i '/swap/s/^/#/' /etc/fstab
swapoff -a

#  Fix prometheus errors
mount --make-rshared /

echo "#!/bin/sh" > /etc/local.d/sharemetrics.start
echo "mount --make-rshared /" >> /etc/local.d/sharemetrics.start
chmod +x /etc/local.d/sharemetrics.start
rc-update add local

#  Fix id error messages
uuidgen > /etc/machine-id

# Update the containerd sandbox_image to the latest version (It's pause:3.9 in K8S v1.30)
sed -i 's/pause:3.8/pause:3.9/' /etc/containerd/config.toml

#  Add kubernetes services on all controlplane and worker nodes
rc-update add containerd
rc-update add kubelet
rc-service containerd start

#  Enable time sync (Not required in 3.20 if using default chrony)
##rc-update add ntpd
##rc-service ntpd start

#  Option 1 - Using flannel as your CNI
#  NOTE: This may no longer be necessary on newer versions of the flannel package
##ln -s /usr/libexec/cni/flannel-amd64 /usr/libexec/cni/flannel

#Option 2 - Using calico as your CNI NOTE: This is required in 3.20 if you use calico
##ln -s /opt/cni/bin/calico /usr/libexec/cni/calico
##ln -s /opt/cni/bin/calico-ipam  /usr/libexec/cni/calico-ipam

#  Pin your versions! If you update and the nodes get out of sync, it implodes.
apk add 'kubelet=~1.30'
apk add 'kubeadm=~1.30'
apk add 'kubectl=~1.30'

#  Note: In the future you will manually have to add a newer version the same way to upgrade.
#  Your blank node is now ready! If it's the first, you'll want to make a control node.

# 3. Setup the Control Plane (New Cluster!) 🦾
# Run this command to start the cluster and then apply a network.

#  do not change subnet
##kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name=$(hostname)
##mkdir ~/.kube
##ln -s /etc/kubernetes/admin.conf /root/.kube/config
##kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

