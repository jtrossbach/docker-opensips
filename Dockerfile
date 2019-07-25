FROM debian:jessie
MAINTAINER Razvan Crainea <razvan@opensips.org>

USER root
ENV DEBIAN_FRONTEND noninteractive
ARG VERSION=2.4

WORKDIR /usr/local/src

RUN apt-get update -qq && apt-get install -y build-essential \
		git bison flex m4 pkg-config libncurses5-dev rsyslog coreutils

RUN git clone https://github.com/OpenSIPS/opensips.git -b $VERSION opensips_$VERSION
RUN cd opensips_$VERSION && make all && make install

RUN echo -e "local0.* -/var/log/opensips.log\n& stop" > /etc/rsyslog.d/opensips.conf
RUN touch /var/log/opensips.log

EXPOSE 5060/udp

COPY run.sh /run.sh

RUN touch /var/log/opensips.log && \
    chgrp -R 0 /var && \
    chmod -R g=u /var && \
    chgrp -R 0 /dev && \
    chmod -R g=u /dev && \
    chmod -R 0 /usr && \
    chmod -R g=u /usr 

ENTRYPOINT ["/run.sh"]
