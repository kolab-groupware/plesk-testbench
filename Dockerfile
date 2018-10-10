FROM centos/systemd

LABEL maintainer="admin@pxts.ch"

ENV PLESK_DISABLE_HOSTNAME_CHECKING 1

RUN yum -y update \
    && yum -y install wget

RUN wget -q -O /root/ai http://autoinstall.plesk.com/plesk-installer

ADD data/LicenseFaker.php /root/
ADD data/kolab.zip /root/
ADD data/seafile.zip /root/
ADD setup.sh /root/setup.sh
ADD run.sh /run.sh
ADD install.sh /install.sh
ADD update.sh /root/update.sh

ADD license /root/license
CMD /usr/sbin/init

# Port to expose
# 21 - ftp
# 25 - smtp
# 53 - dns
# 80 - http
# 110 - pop3
# 143 - imaps
# 443 - https
# 3306 - mysql
# 8880 - plesk via http
# 8443 - plesk via https
# 8447 - autoinstaller
EXPOSE 21 80 443 8880 8443 8447
