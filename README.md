# Plesk test container
This container is used to provide a development and CI test environment for plesk extensions.

You will need:
* A plesk license in this directory in a file called "license"
* An up-to-date data/LicenseFaker.php.
* data/seafile.zip and data/kolab.zip (renamed extension tarballs to install)

To build:
* Run build.sh to get the base container
* Run builddefaultconfiguration.sh to get a container with a basic configuration and the extensions installed.

To run:
* Use start.sh to run the container and `docker exec -ti $CONTAINERID /bin/bash' to attach
* Webinterface is on localhost:8880

# Ports to expose
* 21 - ftp
* 25 - smtp
* 53 - dns
* 80 - http
* 110 - pop3
* 143 - imaps
* 443 - https
* 3306 - mysql
* 8880 - plesk via http
* 8443 - plesk via https
* 8447 - autoinstaller
