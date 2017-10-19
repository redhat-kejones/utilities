#!/usr/bin/env bash

cd /data/images/

qemu-img create -f qcow2 -b rhel7-guest.qcow2 reposyncer.qcow2

virt-install --ram 1024 --vcpus 1 --os-variant rhel7 \
        --disk path=/data/images/reposyncer.qcow2,device=disk,bus=virtio,format=qcow2 \
        --noautoconsole --vnc \
        --network network:external \
        --name reposyncer \
        --cpu host \
        --dry-run --print-xml > /tmp/reposyncer.xml; \
        virsh define --file /tmp/reposyncer.xml;

