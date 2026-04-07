#!/bin/bash

apt-get update
apt-get -y install apt-transport-https wget gnupg

wget -O - https://packages.icinga.com/icinga.key | apt-key add -

DIST=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release); 
echo "deb https://packages.icinga.com/debian icinga-${DIST} main" > /etc/apt/sources.list.d/${DIST}-icinga.list
echo "deb-src https://packages.icinga.com/debian icinga-${DIST} main" >> /etc/apt/sources.list.d/${DIST}-icinga.list

apt-get update
apt-get install -y icinga2a