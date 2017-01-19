#!/bin/bash

# Wait for dhcp
until [[ $internal =~ 163\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; do
    sleep 1
    internal=$(
		ip -o -4 address list dev eth0 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -1
    )
done

echo "==== We have an IPv4 address ===="

ip -4 -o address list dev eth0

# Wait for autoconf
until [[ $internal =~ 2404:[a-zA-z0-9:]+ ]]; do
    sleep 1
    internal=$(
		ip -o -6 address list dev eth0 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -1
    )
done

echo "==== We have an IPv6 address ===="

ip -6 -o address list dev eth0

echo "==== Default routes ===="

ip route get 8.8.8.8
ip route get 2001:4860:4860::8888

echo "==== Ping tests ===="

# Let faucet learn us
ping -c 1 google.com > /dev/null
ping6 -c 1 google.com > /dev/null

echo "+ ping -c 10 google.com"

if ! ping -c 10 google.com | grep " 0% packet loss"; then
    echo "ping -c 10 google.com failed"
    exit 99
fi

echo "+ ping6 -c 10 google.com"

if ! ping6 -c 10 google.com | grep " 0% packet loss"; then
    echo "ping6 -c 10 google.com failed"
    exit 99
fi

echo "==== DNS tests ===="

set -ex
dig +short A google.com @8.8.8.8
dig +short AAAA google.com @8.8.8.8
dig +short A google.com @2001:4860:4860::8888
dig +short AAAA google.com @2001:4860:4860::8888
dig +short A google.com
dig +short AAAA google.com
set +ex

echo "==== Curl tests ===="

echo "+ curl https://nznog.cloud"
nznog_sha256=$(curl https://nznog.cloud | sha256sum | awk '{print $1}')
if [ "$nznog_sha256" != "c9220a0428d909bd55fe6a6069b8bc5d6d148d56c9fa077ffac7c8d6d39625e3" ]; then
    echo "bad sha256sum for nznog.cloud"
    exit 99
else
    echo "valid sha256sum for nznog.cloud"
fi

echo "+ curl https://httpbin.org/html"
httpbin_sha256=$(curl https://httpbin.org/html | sha256sum | awk '{print $1}')
if [ "$httpbin_sha256" != "3f324f9914742e62cf082861ba03b207282dba781c3349bee9d7c1b5ef8e0bfe" ]; then
    echo "bad sha256sum for httpbin.org"
    exit 99
else
    echo "valid sha256sum for httpbin.org"
fi

echo "==== Done ===="

tail -f /dev/null
