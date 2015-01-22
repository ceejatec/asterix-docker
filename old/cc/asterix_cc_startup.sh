#!/bin/bash

su -c /asterix/asterix_joe_startup.sh joe
exec /usr/sbin/sshd -D
