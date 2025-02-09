basevm=alpinebase
snapshot=snap0001
macaddress=("0800274C3130" "080027136687" "080027C3B671")
hosts=("ctlnodea" "nodea-0" "nodea-1")


if ! vboxmanage snapshot alpinebase list|grep -q 'Name'; then
  echo Creating Snapshot $snapshot
  vboxmanage snapshot ${basevm} take $snapshot --description="preparing to make a clone from cli"
fi

for var in "${!hosts[@]}"; do
  echo clone ${hosts[var]}
  vboxmanage clonevm ${basevm} --name=${hosts[var]} --register --options=link --snapshot=${snapshot}
  # echo set MAC ${macaddress[var]} for  ${hosts[var]}
  # vboxmanage modifyvm ${hosts[var]}  --mac-address1=${macaddress[var]}
    sleep 2
  echo starting ${hosts[var]}
  vboxmanage startvm ${hosts[var]} --type headless
  echo
done

