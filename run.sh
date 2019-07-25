#!/bin/bash

HOST_IP=$(ip route get 8.8.8.8 | /usr/bin/head -n +1 | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f 7)

sed -i "s/listen=.*/listen=udp:${HOST_IP}:5060/g" /usr/local/etc/opensips/opensips.cfg

service rsyslog start

/usr/local/sbin/opensipsctl start

/usr/bin/tail -f /var/log/opensips.log
