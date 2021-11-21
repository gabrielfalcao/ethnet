FROM ubuntu:20.04

ARG node_count=3
ARG app_home=/srv/ethereum

ENV \
  APP_HOME=${app_home}

WORKDIR ${APP_HOME}

EXPOSE 3000/tcp 5000/tcp

RUN add-apt-repository --yes --update --enable-source ppa:ethereum/ethereum
RUN apt update
RUN apt install -y bash python3-dev openssl-dev ca-certificates curl wget sed nodejs git jq
RUN apt install -y ethereum puppeth

RUN mkdir -p ${APP_HOME} /srv/tools
COPY *.sh /srv/tools

RUN /srv/tools/create-tree ${APP_HOME} ${node_count}

ENTRYPOINT ["bash"]
