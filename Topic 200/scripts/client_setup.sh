#Install packages Debian
sudo apt install -y collectd python build-essential librrds-perl libjson-perl libhtml-parser-perl apache2

#Install packages in RHEL
sudo yum install -y collectd rrdtool rrdtool-perl perl-HTML-Parser perl-JSON

#Modifying Configuration

#Debian
sudo vim /etc/collectd/collectd.conf

#RHEL
sudo vim /etc/collectd.conf

#Below are the changes required in client side.

Hostname    "debian-lpic1-201"
FQDNLookup   true

LoadPlugin syslog

<Plugin syslog>
        LogLevel info
</Plugin>

#Enable the required plugins by removing “#”.

LoadPlugin cpu
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin network

#Enter the collectd server IP under network plugin and enable all other required plugins.

<Plugin network>
        # client setup:
        <Server "192.168.0.31" "25826">
        </Server>
</Plugin>

<Plugin load>
        ReportRelative true
</Plugin>

<Plugin memory>
        ValuesAbsolute true
        ValuesPercentage false
</Plugin>

#Starting the Client Service
#Finally, enable and start the service.

sudo systemctl start collectd
sudo systemctl enable collectd

#Once service started on client system, switch back to collectd server and reload the interface.
#Now we should get the newly added client in the list.
