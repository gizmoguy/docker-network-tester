#!/bin/bash

sudo ./ovs-docker-with-dhcp del-ports br-demo "$1"
sudo docker stop "$1"
sudo docker rm "$1"
