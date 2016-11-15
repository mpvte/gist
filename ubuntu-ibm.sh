#!/bin/bash

cat << _EOF_ >Dockerfile
FROM ubuntu:14.04
RUN apt-get update && apt-get install -y openssh-server && mkdir /var/run/sshd && echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
_EOF_

cf ic build -t ub:v1 . 

cf ic ip bind $(cf ic ip request | cut -d \" -f 2 | tail -1) $(cf ic run --name=ub -p 22 registry.ng.bluemix.net/`cf ic namespace get`/ub:v1)
