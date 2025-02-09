vms=(
base
ctlnode
node-0
node-1
alpinebase
ctlnodea
nodea-0
nodea-1
)

for i in ${vms[*]}; do
echo $i
VBoxManage modifyvm $i --icon-file=/Users/jimmy/Pictures/icons/kubernetes.png
done
