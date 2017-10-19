#!/usr/bin/env bash

cd /data/images/

for i in rhv1 rhv2 rhv3;
do
	qemu-img create -f qcow2 -b rhel7-guest.qcow2 $i.qcow2;

	virt-install --ram 8192 --vcpus 2 --os-variant rhel7 \
	--disk path=/data/images/$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc --network network:provisioning \
	--network network:external \
	--name $i \
	--dry-run --print-xml > /tmp/$i.xml; \
	virsh define --file /tmp/$i.xml;
done
