#!/bin/bash

# Check if nzbget.conf exists. If not, copy in the sample config
if [ -f /volumes/config/nzbget.conf ]; then
  echo " Using existing nzbget.conf file."
else
  echo "Creating nzbget.conf from template."
  cp /usr/share/nzbget/webui/nzbget.conf /volumes/config/
  sed -i -e "s#\(MainDir=\).*#\1/volumes/downloads#g" /volumes/config/nzbget.conf
  sed -i -e "s#\(ControlIP=\).*#\10.0.0.0#g" /volumes/config/nzbget.conf
  sed -i -e "s#\(UMask=\).*#\1000#g" /volumes/config/nzbget.conf
  sed -i -e "s#\(ScriptDir=\).*#\1/volumes/config/ppscripts#g" /volumes/config/nzbget.conf
  sed -i -e "s#\(QueueDir=\).*#\1/volumes/config/queue#g" /volumes/config/nzbget.conf
  sed -i -e "s#\(LogFile=\).*#\1/volumes/config/log/nzbget.logs#g" /volumes/config/nzbget.conf
  chown nobody:users /volumes/config/nzbget.conf
  mkdir -p /volumes/downloads/dst
  chown -R nobody:users /volumes/downloads
fi

# Verify and create come directories
if [[ ! -e /volumes/config/queue ]]; then
  mkdir -p /volumes/config/queue
  chown -R nobody:users /volumes/config/queue
fi

if [[ ! -e /volumes/config/log ]]; then
  mkdir -p /volumes/config/log
  chown -R nobody:users /volumes/config/log
fi

if [[ ! -e /volumes/config/ppscripts ]]; then
  mkdir -p /volumes/config/ppscripts
  chown -R nobody:users /volumes/config/ppscripts
fi

# Add some post-processing scripts
# nzbToMedia
if [[ ! -e /volumes/config/ppscripts/nzbToMedia ]]; then
  echo "Downloading nzbToMedia."
  mkdir -p /volumes/config/ppscripts/nzbToMedia
  wget -nv https://github.com/clinton-hall/nzbToMedia/archive/master.tar.gz -O - | tar --strip-components 1 -C /volumes/config/ppscripts/nzbToMedia -zxf -
fi

# Videosort
if [[ ! -e /volumes/config/ppscripts/videosort ]]; then
  echo "Downloading videosort."
  mkdir -p /volumes/config/ppscripts/videosort
  wget -nv http://sourceforge.net/projects/nzbget/files/ppscripts/videosort/videosort-ppscript-5.0.zip/download -O /volumes/config/ppscripts/videosort-ppscript-5.0.zip
  unzip -qq /volumes/config/ppscripts/videosort-ppscript-5.0.zip
  rm /volumes/config/ppscripts/videosort-ppscript-5.0.zip
fi

# NotifyXBMC.py
if [[ ! -e /volumes/config/ppscripts/NotifyXBMC.py ]]; then
  echo "Downloading NotifyXBMC."
  wget -nv http://forum.nzbget.net/download/file.php?id=193 -O /volumes/config/ppscripts/NotifyXBMC.py
fi