#!/bin/bash

if [ "$IPv4" = true ]; then
  # Wait for dhcp
  until [[ $v4_default_route =~ via.*dev\ eth0 ]]; do
      sleep 1
      v4_default_route=$(
          ip -o -4 route get 8.8.8.8
      )
  done

  echo "==== We have an IPv4 address ===="

  ip -o -4 address list dev eth0
  ip -o -4 route get 8.8.8.8
fi

if [ "$IPv6" = true ]; then
  # Wait for autoconf
  until [[ $v6_default_route =~ via.*dev\ eth0 ]]; do
      sleep 1
      v6_default_route=$(
          ip -o -6 route get 2001:4860:4860::8888
      )
  done

  echo "==== We have an IPv6 address ===="

  ip -o -6 address list dev eth0 | grep -v fe80
  ip -o -6 route get 2001:4860:4860::8888
fi

echo "==== Ping tests ===="

if [ "$IPv4" = true ]; then
    # Let faucet learn us
    ping -c 1 google.com > /dev/null

    echo "+ ping -c 10 google.com"

    if ! ping -c 10 google.com | grep " 0% packet loss"; then
        echo "ping -c 10 google.com failed"
        exit 99
    fi
fi
if [ "$IPv6" = true ]; then
    # Let faucet learn us
    ping6 -c 1 google.com > /dev/null

    echo "+ ping6 -c 10 google.com"

    if ! ping6 -c 10 google.com | grep " 0% packet loss"; then
        echo "ping6 -c 10 google.com failed"
        exit 99
    fi
fi

echo "==== DNS tests ===="

set -ex
dig +short A google.com
dig +short AAAA google.com
set +ex

echo "==== Curl tests ===="

if [ "$IPv4" = true ]; then
    echo "+ curl https://httpbin.org/html"
    httpbin_sha256=$(curl https://httpbin.org/html | sha256sum | awk '{print $1}')
    if [ "$httpbin_sha256" != "3f324f9914742e62cf082861ba03b207282dba781c3349bee9d7c1b5ef8e0bfe" ]; then
        echo "bad sha256sum for httpbin.org"
        exit 99
    else
        echo "valid sha256sum for httpbin.org"
    fi

    echo "+ curl https://example.org"
    example_sha256=$(curl https://example.org | sha256sum | awk '{print $1}')
    if [ "$example_sha256" != "3587cb776ce0e4e8237f215800b7dffba0f25865cb84550e87ea8bbac838c423" ]; then
        echo "bad sha256sum for example.org"
        exit 99
    else
        echo "valid sha256sum for exmaple.org"
    fi
fi

if [ "$IPv6" = true ]; then
    echo "+ curl https://example.org"
    example_sha256=$(curl https://example.org | sha256sum | awk '{print $1}')
    if [ "$example_sha256" != "3587cb776ce0e4e8237f215800b7dffba0f25865cb84550e87ea8bbac838c423" ]; then
        echo "bad sha256sum for example.org"
        exit 99
    else
        echo "valid sha256sum for exmaple.org"
    fi
fi

echo "==== Done ===="

tail -f /dev/null
