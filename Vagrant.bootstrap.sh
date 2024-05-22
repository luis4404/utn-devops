#!/bin/bash

sudo apt update
sudo apt install -y apache2

if [ ! -f "/swapdir/swapfile" ]; then
	sudo mkdir /swapdir
	cd /swapdir
	sudo dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=4000000
	sudo chmod 0600 /swapdir/swapfile
	sudo mkswap -f  /swapdir/swapfile
	sudo swapon swapfile
	echo "/swapdir/swapfile       none    swap    sw      0       0" | sudo tee -a /etc/fstab /etc/fstab
	sudo sysctl vm.swappiness=10
	echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
fi

if [ -f "/tmp/utn-dev.conf" ]; then
    sudo mv /tmp/utn-dev.conf /etc/apache2/sites-available
    sudo a2ensite utn-dev.conf
    sudo a2dissite 000-default.conf
    sudo service apache2 reload
fi

ROOT="/var/www"
ABSOLUTE_PATH="$ROOT/utn-devops-app"

if [ ! -d "$ROOT" ]; then
	sudo mkdir -p $ROOT
fi

if [ ! -d "$ABSOLUTE_PATH" ]; then
	cd $ROOT
	sudo git clone https://github.com/Fichen/utn-devops-app.git
	cd $ABSOLUTE_PATH
	sudo git checkout unidad-1
fi