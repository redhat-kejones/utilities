#!/usr/bin/env bash

cd /data/images/

for i in ctrl01 ctrl02 ctrl03 compute01 compute02 ceph01 ceph02 ceph03 util;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i.qcow2 41G;
done

for i in ceph01 ceph02 ceph03;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i-storage.qcow2 40G;
done

for i in ctrl01	ctrl02 ctrl03;
do
	virt-install --ram 4096 --vcpus 1 --os-variant rhel7 \
	--disk path=/data/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc --network network:provisioning \
	--network network:mgmt --network network:external \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done

for i in compute01 compute02;
do
	virt-install --ram 4096 --vcpus 4 --os-variant rhel7 \
	--disk path=/data/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc --network network:provisioning \
	--network network:mgmt --network network:external \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done

for i in ceph01 ceph02 ceph03;
do
	virt-install --ram 4096 --vcpus 1 --os-variant rhel7 \
	--disk path=/data/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/data/images/overcloud-$i-storage.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc --network network:provisioning \
	--network network:mgmt --network network:external \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done

virt-install --ram 4096 --vcpus 1 --os-variant rhel7 \
        --disk path=/data/images/overcloud-util.qcow2,device=disk,bus=virtio,format=qcow2 \
        --noautoconsole --vnc --network network:provisioning \
        --network network:mgmt --network network:external \
        --name overcloud-util \
        --cpu SandyBridge,+vmx \
        --dry-run --print-xml > /tmp/overcloud-networker.xml; \
        virsh define --file /tmp/overcloud-networker.xml;
