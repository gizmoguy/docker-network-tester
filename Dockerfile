FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y install iproute2 iputils-ping curl dnsutils screen tcpdump

ADD bin/tests.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/tests.sh

CMD ["/usr/local/bin/tests.sh"]
