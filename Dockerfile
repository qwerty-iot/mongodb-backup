FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y ca-certificates curl apt-transport-https lsb-release gnupg sshpass
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc| gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list

RUN curl -sL https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

RUN apt update && apt install -y azure-cli mongodb-database-tools mongodb-org-shell && rm -rf /var/lib/apt/lists/* && apt clean

COPY run.sh /root/run.sh

WORKDIR /root/

CMD ["bash","./run.sh"]