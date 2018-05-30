#!/bin/bash
if [ ! -e /etc/inputrc ]; then
    ln -sfv /usr/share/defaults/etc/inputrc /etc/inputrc
fi
