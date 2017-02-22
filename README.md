```
docker build -t gizmoguy/network-tester .
docker run --rm -it --network=none gizmoguy/network-tester
sudo ovs-docker-with-dhcp add-port br-wired eth0 [docker-container-id]
```
