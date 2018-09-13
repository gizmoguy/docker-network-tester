## Build docker

```
docker build -t gizmoguy/network-tester .
```

## Run docker

Run one:

```
IPv4=true IPv6=true BRIDGE=br-wired ./start-a-docker.sh
```

Run many:

```
IPv4=true IPv6=true BRIDGE=br-wired ./runlots.sh
```
