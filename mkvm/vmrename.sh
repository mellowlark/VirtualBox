for vm in ctlnode node-0 node-1; do
  vboxmanage modifyvm $vm --name=${vm}.m
done
