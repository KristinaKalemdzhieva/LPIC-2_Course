#Install icingaweb2
apt-get install icingaweb2 icingacli

#Install Web server
apt-get install nginx
apt-get install php php-common

#Generate token to configure icingaweb2
icingacli setup token create

#Show token
icingacli setup token show

#Create a database
mysql -u root -p
CREATE DATABASE icingaweb2;
GRANT ALL ON icingaweb2.* TO icingaweb2@localhost IDENTIFIED BY 'CHANGEME';
quit