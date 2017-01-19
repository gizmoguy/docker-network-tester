#!/bin/bash

# Spin up dockers
for i in `seq 1 100`; do
    sudo docker run -d --network=none gizmoguy/network-tester
done

# Kick off dockers by giving them network
for id in `sudo docker ps | grep gizmoguy/network-tester | awk '{print $1}'`; do
    sudo ./ovs-docker-with-dhcp add-port br-wired eth0 "$id"
done
