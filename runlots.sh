#!/bin/bash

for i in `seq 1 100`; do
    id=$(docker run -d --network=none gizmoguy/network-tester)
    sudo ovs-docker-with-dhcp add-port br-wired eth0 "$id"
done