#Install pre reqs and collecd in debian
sudo apt install -y \
git \
apache2 \
gzip \
python \
build-essential \
emboss \
bioperl \
ncbi-blast+ \
librrds-perl \
libjson-perl \
libhtml-parser-perl \
libjson-perl \
libtext-csv-perl \
libfile-slurp-perl \
liblwp-protocol-https-perl \
libwww-perl \
libconfig-general-perl \
libregexp-common-perl \
collectd

#Enable the Web module
sudo a2enmod cgi cgid
sudo systemctl restart apache2

#Installing Perl Modules
sudo cpan jSON
sudo cpan CGI

#Enable CGI support for collectd
sudo vim /etc/apache2/sites-available/000-default.conf

<Directory /var/www/html/collectd-web/cgi-bin>
Options Indexes ExecCGI
AllowOverride All
AddHandler cgi-script .cgi
Require all granted
</Directory>

#Apache configuration
sudo vim /etc/apache2/apache2.conf
Include ports.conf

sudo vim /etc/apache2/ports.conf
Listen 0.0.0.0:80

sudo systemctl restart apache2

#Configuring Collectd
sudo vim /etc/collectd/collectd.conf

#Uncomment plugin for network

LoadPlugin network

#By following under network plugin section,
#uncomment the server section and replace 127.0.0.1 to 0.0.0.0.

<Plugin network>
        # server setup:
        <Listen "0.0.0.0" "25826">
        </Listen>
</Plugin>

sudo systemctl restart apache2

#Enable Web Interface
git clone https://github.com/httpdss/collectd-web.git
cd collectd-web/cgi-bin/
chmod +x graphdefs.cgi
cd ..
vim runserver.py

#Replace 127.0.0.1 to 0.0.0.0 in below line.
httpd = BaseHTTPServer.HTTPServer(("127.0.0.1", PORT), Handler)

#It’s time to run the python script to start in background.
./runserver.py &
