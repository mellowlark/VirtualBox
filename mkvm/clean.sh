echo poweroff
vboxmanage controlvm ctlnode poweroff
vboxmanage controlvm node-0 poweroff
vboxmanage controlvm node-1 poweroff
echo delete
vboxmanage unregistervm ctlnode --delete
vboxmanage unregistervm node-0 --delete
vboxmanage unregistervm node-1 --delete

