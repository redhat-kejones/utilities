#!/usr/bin/env bash

cd /data/images/

for i in ironic01 ironic02 ironic03 ironic04;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i.qcow2 21G;

	virt-install --ram 4096 --vcpus 1 --os-variant rhel7 \
	--disk path=/data/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc --network network:ironic \
	--name overcloud-$i \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done
