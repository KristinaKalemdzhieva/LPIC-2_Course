#!/bin/bash

apt update && apt -y full-upgrade

sudo apt install vim wget curl build-essential unzip openssl libssl-dev apache2 php libapache2-mod-php php-gd libgd-dev

NAGIOS_VER=$(curl -s https://api.github.com/repos/NagiosEnterprises/nagioscore/releases/latest|grep tag_name | cut -d '"' -f 4)
wget https://github.com/NagiosEnterprises/nagioscore/releases/download/$NAGIOS_VER/$NAGIOS_VER.tar.gz
tar xvzf $NAGIOS_VER.tar.gz

cd $NAGIOS_VER
./configure --with-httpd-conf=/etc/apache2/sites-enabled

sudo make install-groups-users
sudo usermod -a -G nagios www-data
Compile and Install the main Nagios programs

sudo make all
sudo make install

sudo make install-daemoninit

sudo make install-commandmode

sudo make install-config

sudo make install-webconf
sudo a2enmod rewrite cgi

sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
sudo chmod 640 /usr/local/nagios/etc/htpasswd.users

VER=$(curl -s https://api.github.com/repos/nagios-plugins/nagios-plugins/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/release-//')
wget https://github.com/nagios-plugins/nagios-plugins/releases/download/release-$VER/nagios-plugins-$VER.tar.gz
tar xvf nagios-plugins-$VER.tar.gz
cd nagios-plugins-$VER
./configure --with-nagios-user=nagios --with-nagios-group=nagios
sudo make
sudo make install

sudo ufw allow 80
sudo ufw reload
sudo systemctl restart apache2
sudo systemctl start nagios.service