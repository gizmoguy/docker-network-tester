FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y install iproute2 iputils-ping curl dnsutils screen tcpdump

ADD test.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/test.sh

CMD ["/usr/local/bin/test.sh"]
