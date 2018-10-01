#!/bin/bash
set -e
source etc/conf.sh
  # Install dependencies
sudo -v
sudo apt update
sudo apt install -y build-essential binutils-doc autoconf flex bison libjpeg-dev libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev \
  libncurses5-dev automake libtool libffi-dev curl git tmux gettext nginx rabbitmq-server redis-server circus postgresql-9.5 postgresql-contrib-9.5 \
  postgresql-doc-9.5 postgresql-server-dev-9.5 python3 python3-pip python-dev python3-dev python-pip virtualenvwrapper libxml2-dev libxslt-dev libssl-dev libffi-dev
sudo pip3 install virtualenvwrapper
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
  # Add new user with password set in etc/conf.sh
set +e
sudo useradd -m -d /home/taiga -p $(openssl passwd -1 $LINUXPASSWORD) taiga
set -e
  # Let taiga sudo without password for scripting, being removed on cleanup (need to be manually removed if script fails)
sudo adduser taiga sudo
sudo bash -c 'echo "taiga ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers'
  # Install taiga-backend
sudo su taiga -c bin/4-backend.sh
  # Install taiga-frontend
sudo su taiga -c bin/5-frontend.sh
  # Install circus
sudo su taiga -c bin/7.1-startExpose.sh
  # Install nginx
sudo su taiga -c bin/7.2-nginx.sh

sudo hostname $DOMAIN
sudo bash -c "echo $DOMAIN > /etc/hostname"
echo -e "127.0.0.1	localhost\n127.0.1.1	$DOMAIN\n::1     localhost\n$IP $DOMAIN" > ~/hosts
sudo mv ~/hosts /etc/hosts

  # Cleanup
sed -i 's|^taiga.*||g' /etc/sudoers
