#!/bin/bash
if [ ! -e /etc/inputrc ]; then
    install -v -m644 /usr/share/defaults/etc/inputrc /etc
fi