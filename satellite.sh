#!/usr/bin/env bash

cd /var/lib/libvirt/images/

qemu-img create -f qcow2 sat6.qcow2 300G

virt-resize --expand /dev/sda1 /data/images/rhel7-guest.qcow2 /var/lib/libvirt/images/sat6.qcow2;

virt-install --ram 12288 --vcpus 2 --os-variant rhel7 \
  --disk path=/var/lib/libvirt/images/sat6.qcow2,device=disk,bus=virtio,format=qcow2 \
  --noautoconsole --vnc --network network:external \
  --name sat6 --cpu host \
  --dry-run --print-xml > /tmp/sat6.xml; \
  virsh define --file /tmp/sat6.xml;
