#!/usr/bin/env bash

cd /data/images/

#qemu-img create -f qcow2 rhv-grafton1.qcow2 200G
#virt-resize --expand /dev/sda1 rhel7-guest.qcow2 rhv-grafton1.qcow2

qemu-img create -f qcow2 -o preallocation=metadata rhv-grafton1-storage.qcow2 130G;

virt-install --ram 8192 --vcpus 2 --os-variant rhel7 \
--disk path=/data/images/rhv-grafton1.qcow2,device=disk,bus=virtio,format=qcow2 \
--disk path=/data/images/rhv-grafton1-storage.qcow2,device=disk,bus=virtio,format=qcow2 \
--noautoconsole --vnc --network network:provisioning \
--network network:external \
--name rhv-grafton1 \
--dry-run --print-xml > /tmp/rhv-grafton1.xml; \
virsh define --file /tmp/rhv-grafton1.xml;

#for i in grafton2 grafton3;
#do
#	qemu-img create -f qcow2 -b rhel7-guest.qcow2 rhv-$i.qcow2;
#
#	qemu-img create -f qcow2 -o preallocation=metadata rhv-$i-storage.qcow2 130G;
#
#	virt-install --ram 8192 --vcpus 2 --os-variant rhel7 \
#	--disk path=/data/images/rhv-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
#	--disk path=/data/images/rhv-$i-storage.qcow2,device=disk,bus=virtio,format=qcow2 \
#	--noautoconsole --vnc --network network:provisioning \
#	--network network:external \
#	--name rhv-$i \
#	--dry-run --print-xml > /tmp/rhv-$i.xml; \
#	virsh define --file /tmp/rhv-$i.xml;
#done
