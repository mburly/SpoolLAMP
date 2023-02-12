#!/bin/bash
#
# Install necessary packages to host a LAMP application
#
# Prerequisites: Logged in as root or user has sudo privileges
# 
#
# Available optional packages:
# Certbot - Used to get free local SSL certificates
# Croc - Easy file sharing between machines
# Pip - Python package installer
# XFCE - Linux desktop environment
# XRDP - Linux remote desktop connection
#
#

options_o=()
certbot=false
croc=false
pip=false
xfce=false
xrdp=false

while getopts "o:" opt; do
 case $opt in
  o)
   shift
   while [ $# -gt 0 ] && [ "$!" != "-" ]; do
    if [ "$1" == "certbot" ]; then
     certbot=true
    fi
    if [ "$1" == "croc" ]; then
     croc=true
    fi
    if [ "$1" == "pip" ]; then
     pip=true
    fi
    if [ "$1" == "xfce" ]; then
     xfce=true
    fi
    if [ "$1" == "xrdp" ]; then
     xrdp=true
    fi
    options_o+=("$1")
    shift
   done
   ;;
  \?)
   echo "Invalid option: -$OPTARG" >&2
   exit 1
   ;;
  esac
done

sudo apt update
sudo apt -y install git curl
sudo apt -y install apache2 mariadb-server php php-common libapache2-mod-php
sudo mysql_secure_installation
sudo apt -y install phpmyadmin


if [ $certbot == true ]; then
 sudo apt -y install snapd
 sudo snap install core
 sudo snap install --classic certbot
fi

if [ $croc == true ]; then
 curl https://getcroc.schollz.com | bash
fi

if [ $pip == true ]; then
 sudo apt -y install python3-pip
 fi

if [ $xfce == true ]; then
 sudo apt -y install task-xfce-desktop xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
fi

if [ $xrdp == true ]; then
 sudo apt -y install xrdp
 sudo adduser xrdp ssl-cert
fi
