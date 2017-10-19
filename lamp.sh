#!/usr/bin/env bash

cd /data/images/

qemu-img create -f qcow2 -b rhel7-guest.qcow2 lamp.qcow2

virt-install --ram 2048 --vcpus 1 --os-variant rhel7 \
        --disk path=/data/images/lamp.qcow2,device=disk,bus=virtio,format=qcow2 \
        --noautoconsole --vnc \
        --network network:external \
        --name lamp \
        --cpu host \
        --dry-run --print-xml > /tmp/lamp.xml; \
        virsh define --file /tmp/lamp.xml;

