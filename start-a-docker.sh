#!/bin/bash

IPv4="${IPv4:=false}"
IPv6="${IPv6:=false}"

id=$(sudo docker run --rm -d --network=none \
     -v `pwd`/etc/resolv.conf:/etc/resolv.conf \
     --sysctl net.ipv6.conf.all.disable_ipv6=0 \
     -e IPv4=$IPv4 -e IPv6=$IPv6 \
     gizmoguy/network-tester | cut -c1-12)
sudo ./bin/ovs-docker add-port ${BRIDGE} eth0 "$id"
