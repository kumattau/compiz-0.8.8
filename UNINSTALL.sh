#!/bin/sh -x

sudo apt-get remove --purge `dpkg -l | grep compiz | grep 0.8.8 | awk '{print $2}'`
