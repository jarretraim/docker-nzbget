# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive

# Install nzbget
RUN add-apt-repository -y ppa:mc3man/trusty-media \
	&& apt-get update -qq \
	&& apt-get install -qy ffmpeg nzbget wget unrar unzip p7zip

# Data Storage & Permissions
RUN mkdir -p /volumes/config /volumes/downloads \
  	&& chown -R nobody:users /volumes

# Add firstrun.sh to execute during container startup
ADD firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh

# Add nzbget to runit
RUN mkdir /etc/service/nzbget
ADD nzbget.sh /etc/service/nzbget/run
RUN chmod +x /etc/service/nzbget/run

# Enable SSH
# RUN rm -f /etc/service/sshd/down
# ADD id_rsa.pub /tmp/id_rsa.pub
# RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub
# EXPOSE 22

# Web Interface
EXPOSE 6789

# Path to a directory that only contains the nzbget.conf
VOLUME /volumes/config
VOLUME /volumes/downloads
