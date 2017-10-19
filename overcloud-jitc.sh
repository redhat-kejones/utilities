#!/usr/bin/env bash

cd /data/images/

for i in compute01 block01 object01;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i.qcow2 31G;
done

for i in compute01 block01 object01;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i-storage.qcow2 20G;
done

#for i in ctrl01;
#do
#	virt-install --ram 4096 --vcpus 1 --os-variant rhel7 \
#	--disk path=/data/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
#	--noautoconsole --vnc --network network:provisioning \
#	--network network:mgmt --network network:external \
#	--name overcloud-$i \
#	--cpu host \
#	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
#	virsh define --file /tmp/overcloud-$i.xml;
#done

for i in compute01 block01 object01;
do
	virt-install --ram 4096 --vcpus 1 --os-variant rhel7 \
	--disk path=/data/images/overcloud-$i.qcow2,device=disk,bus=scsi,format=qcow2 \
	--disk path=/data/images/overcloud-$i-storage.qcow2,device=disk,bus=scsi,format=qcow2 \
	--noautoconsole --vnc --network network:jitc-prov \
	--network network:external \
	--name overcloud-$i \
	--cpu host \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done
