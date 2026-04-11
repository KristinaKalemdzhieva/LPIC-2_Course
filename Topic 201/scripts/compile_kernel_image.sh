#!/bin/bash

# Copy the default Debian kernel configuration
cp /boot/config-$(uname -r) /usr/src/linux/.config

# Disable trusted and revocation keys to avoid compilation errors on Debian/Ubuntu
sed -i 's/CONFIG_SYSTEM_TRUSTED_KEYS=.*/CONFIG_SYSTEM_TRUSTED_KEYS=""/' /usr/src/linux/.config
sed -i 's/CONFIG_SYSTEM_REVOCATION_KEYS=.*/CONFIG_SYSTEM_REVOCATION_KEYS=""/' /usr/src/linux/.config

# Create and enable a swap file to provide enough RAM for the compilation process
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Display the current swap usage to verify the swapfile is active
swapon -s

# Enter the source directory and start the kernel image compilation using all CPU cores
cd /usr/src/linux
sudo make -j $(nproc) bzImage