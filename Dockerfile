FROM centos/systemd

LABEL maintainer="admin@pxts.ch"

ENV PLESK_DISABLE_HOSTNAME_CHECKING 1

RUN yum -y update \
    && yum -y install wget vim python

RUN wget -q -O /root/ai http://autoinstall.plesk.com/plesk-installer

ADD update.sh /root/update.sh
CMD /usr/sbin/init
