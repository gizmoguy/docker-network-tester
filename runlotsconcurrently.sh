#!/bin/bash

# Spin up dockers
for i in `seq 1 100`; do
    sudo docker run --rm -d --network=none \
        -v `pwd`/etc/resolv.conf:/etc/resolv.conf \
        --sysctl net.ipv6.conf.all.disable_ipv6=0 \
        -e IPv4=$IPv4 -e IPv6=$IPv6 \
        gizmoguy/network-tester
done

# Kick off dockers by giving them network
for id in `sudo docker ps | grep gizmoguy/network-tester | awk '{print $1}'`; do
    sudo ./ovs-docker-with-dhcp add-port ${BRIDGE} eth0 "$id"
done
