#!/bin/bash

#download latest version
cd /usr/src

wget --progress=bar https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.12.1.tar.xz

#extract files
tar xJvf linux-6.12.1.tar.xz

#create a simbolic link linux
ln -s linux-6.12.1 linux