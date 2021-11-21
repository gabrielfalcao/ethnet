FROM ubuntu:20.04

ARG node_count=3
ARG ethereum_path=/srv/ethereum

ENV \
  ETHEREUM_PATH=${ethereum_path}


EXPOSE 3000/tcp 5000/tcp

RUN apt update
RUN apt install -y bash python3-dev openssl-dev ca-certificates curl wget sed nodejs git jq ack-grep software-properties-common
RUN add-apt-repository --yes --update --enable-source ppa:ethereum/ethereum
RUN apt update
RUN apt install -y ethereum puppeth

RUN mkdir -p ${ETHEREUM_PATH} /srv/tools
COPY *.sh /srv/tools

WORKDIR /srv/tools
RUN /srv/tools/create-tree ${ETHEREUM_PATH} ${node_count}

ENTRYPOINT ["bash"]
