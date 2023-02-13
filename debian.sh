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
# Suppress output of apt commands, instead put own echo in place saying Done!
#
#


options_o=()
ip=$(curl -s https://api.ipify.org)
certbot=false
croc=false
pip=false
xfce=false
xrdp=false
all=false

while getopts "o:" opt; do
 case $opt in
  o)
   shift
   while [ $# -gt 0 ] && [ "$!" != "-" ]; do
    if [ "$1" == "all" ]; then
     all=true
     break
    fi
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

echo -e "\n\n"
echo -e "\033[38;5;213m                     __    \033[0m"
echo -e "\033[38;5;51m(\,-----------------'()'--o\033[0m"
echo -e "\033[38;5;213m(_    _Spool LAMP_    /~\" \033[0m"
echo -e "\033[38;5;51m  (_)_)           (_)_)    \033[0m"
echo -e "Starting installation...\n\n"

sudo apt -qq -y update
sudo apt -qq -y upgrade
sudo apt -y -qq install git curl
sudo apt -y -qq install apache2 mariadb-server php php-common libapache2-mod-php
sudo mysql_secure_installation
sudo apt -y -qq install phpmyadmin

if [ $all == true ]; then
  sudo apt -y install snapd
  sudo snap install core
  sudo snap install --classic certbot
  curl https://getcroc.schollz.com | bash
  sudo apt -y -qq install python3-pip
  sudo apt -y -qq install task-xfce-desktop xfce4 
  sudo apt -y -qq dbus-x11 x11-xserver-utils
  sudo apt -y -qq install xrdp
  sudo adduser xrdp ssl-cert
else
 if [ $certbot == true ]; then
  sudo apt -y -qq install snapd
  sudo snap install core
  sudo snap install --classic certbot
 fi

 if [ $croc == true ]; then
  curl https://getcroc.schollz.com | bash
 fi

 if [ $pip == true ]; then
  sudo apt -y -qq install python3-pip
 fi

 if [ $xfce == true ]; then
  sudo apt -y -qq install task-xfce-desktop xfce4 dbus-x11 x11-xserver-utils
 fi

 if [ $xrdp == true ]; then
  sudo apt -y -qq install xrdp
  sudo adduser xrdp ssl-cert
 fi
fi

echo -e "\n\n"
echo -e "\033[38;5;213m                     __    \033[0m"
echo -e "\033[38;5;51m(\,-----------------'()'--o\033[0m"
echo -e "\033[38;5;213m(_    _Spool LAMP_    /~\" \033[0m"
echo -e "\033[38;5;51m  (_)_)           (_)_)    \033[0m"
echo -e "\n"
echo -e "LAMP web server installation \033[32mSUCCESS!\033[0m\n"
echo -e "Homepage: http://$ip"
echo -e "Visit phpMyAdmin: http://$ip/phpmyadmin"
echo -e "\nFor further Apache configuration for your applicaton's needs, see /etc/apache2"
echo -e "If you installed XFCE, you need to open port 443 before you can use RDP.\n\n"