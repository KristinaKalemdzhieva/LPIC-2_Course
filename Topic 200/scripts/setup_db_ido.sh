#!/bin/bash

Install MySQL Server
apt-get install mariadb-server mariadb-client
mysql_secure_installation

#Install IDO Feature
apt-get install icinga2-ido-mysql

#Set up MySQL database
mysql -u root -p
GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga';
quit
mysql -u root -p icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql

icinga2 feature enable ido-mysql
systemctl restart icinga2