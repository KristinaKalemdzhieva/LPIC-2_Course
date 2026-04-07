#Step 1: Install Required Packages

sudo apt update
sudo apt install software-properties-common
sudo apt install nginx
sudo apt install curl vim acl composer fping git graphviz imagemagick mariadb-client \
mariadb-server mtr-tiny nginx-full python3-memcache python3-mysqldb snmp snmpd whois php-snmp rrdtool librrds-perl

#Step 2: Install PHP on Debian

sudo apt -y install php php-common
sudo apt -y install php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd \
php-mbstring php-curl php-xml php-pear php-bcmath php-gmp php-ldap

#Step 3: Database Configuration for Cacti

#Login to your DataBase
sudo systemctl enable mysql
sudo systemctl restart mysql
sudo mysql -u root -p

#Create Database and cacti user
CREATE DATABASE cacti;
CREATE USER 'cactiuser'@'localhost' IDENTIFIED BY 'vagrant'; ## Make it strong
GRANT ALL PRIVILEGES ON cacti.* TO 'cactiuser'@'localhost';
FLUSH PRIVILEGES;
EXIT

#Grant database user access to the MySQL TimeZone database and select permission
sudo mysql -u root -p mysql < /usr/share/mysql/mysql_test_data_timezone.sql
sudo mysql -u root -p

GRANT SELECT ON mysql.time_zone_name TO cactiuser@localhost;
ALTER DATABASE cacti CHARACTER SET = 'utf8mb4'  COLLATE = 'utf8mb4_unicode_ci';
FLUSH PRIVILEGES;
EXIT

#Open MariaDB file and add the lines below under [mysqld] section for an optimized database
sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf

# Add the following under [mariadb]
[mariadb]

innodb_file_format=Barracuda
innodb_large_prefix=1
collation-server=utf8mb4_unicode_ci
character-set-server=utf8mb4
innodb_doublewrite=OFF
max_heap_table_size=128M
tmp_table_size=128M
join_buffer_size=128M
innodb_buffer_pool_size=1G
innodb_flush_log_at_timeout=3
innodb_read_io_threads=32
innodb_write_io_threads=16
innodb_io_capacity=5000
innodb_io_capacity_max=10000
innodb_buffer_pool_instances=9

#Restart MariaDB
sudo systemctl restart mysql

#Step 4: Configure PHP-FPM for Cacti use

sudo vim /etc/php/*/fpm/php.ini
sudo vim /etc/php/7.4/apache2/php.ini
sudo vim /etc/php/7.4/cli/php.ini


# Under [Date] uncoment the date.timezone line and add your timezone.
date.timezone = Africa/Nairobi ## Input your Time zone
max_execution_time = 300       ## Increase max_execution_time
memory_limit = 512M            ## Increase memory limit

#Update the address in which FPM will accept FastCGI requests.
sudo vim /etc/php/*/fpm/pool.d/www.conf
listen = /run/php/php-fpm.sock

#Restart PHP-FPM
sudo systemctl restart php*-fpm.service

#Step 5: Configure Nginx Webserver

#Delete the default page that loads up after fresh installation of Nginx

sudo rm /etc/nginx/sites-enabled/default

#Create a file as shown and add the following in it
sudo vim /etc/nginx/conf.d/cacticonfig.conf

#Paste and modify below data
server {
 listen      80;
 server_name debian-lpic-201.cacti.com;
 root        /var/www/html;
 index       index.php;
 access_log  /var/log/nginx/cacti_access.log;
 error_log   /var/log/nginx/cacti_error.log;
 charset utf-8;
 gzip on;
 gzip_types text/css application/javascript text/javascript application/x-javascript image/svg+xml text/plain text/xsd text/xsl text/xml image/x-icon;
 location / {
   try_files $uri $uri/ /index.php?$query_string;
  }
  location /api/v0 {
   try_files $uri $uri/ /api_v0.php?$query_string;
  }
  location ~ .php {
   include fastcgi.conf;
   fastcgi_split_path_info ^(.+.php)(/.+)$;
   fastcgi_pass unix:/run/php/php-fpm.sock;
  }
  location ~ /.ht {
   deny all;
  }
 }

#Restart nginx
sudo systemctl restart nginx

#Step 6: Install Cacti server on Debian 11 / Debian 10

#Download using curl
curl -sLO https://www.cacti.net/downloads/cacti-latest.tar.gz

#Download using wget
wget https://www.cacti.net/downloads/cacti-latest.tar.gz

#After it is done downloading, extract the Cacti archive
tar -zxvf cacti-latest.tar.gz

#Move the files to our web root directory and change the name of the Directory
sudo mv cacti-1* /var/www/html/
sudo mv /var/www/html/cacti-*/ /var/www/html/cacti

#Change ownership for the cacti files
sudo chown -R www-data:www-data /var/www/html/

#Import the default Cacti database data to the Cacti database.
sudo mysql -u root -p cacti < /var/www/html/cacti/cacti.sql

#Open the Cacti configuration file to input database information.
sudo vim /var/www/html/cacti/include/config.php

$database_type = "mysql";
$database_default = "cacti";
$database_hostname = "localhost";
$database_username = "cactiuser";
$database_password = "vagrant";
$database_port = "3306";
$database_ssl = false;

#Validate nginx configurations syntax:
sudo nginx  -t

nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
After you are done with the configuration, restart the webserver.

#Restart Nginx
sudo systemctl restart nginx

#Step 7: Edit the crontab file.

#In order for Cacti to poll every few minutes, you may need to add the following in your crontab
sudo vim /etc/cron.d/cacti
*/5 * * * * www-data php /var/www/html/cacti/poller.php > /dev/null 2>&1
#That will cause Cacti to poll every five minutes.

#Step 8: Web installer

#Now head to the web installer and follow the on-screen instructions.
http:// IP or FQDN /cacti

#That should load the installer similar to the one below.
#Enter default username and password which is admin and admin