#!/bin/bash

id=$(sudo docker run -d --network=none gizmoguy/network-tester | cut -c1-12)
sudo ./ovs-docker-with-dhcp add-port br-wired eth0 "$id"
