#!/bin/bash

sudo apt update
sudo apt remove -y apache2

if [ ! -d "/var/db/mysql" ]; then
	sudo mkdir -p /var/db/mysql
fi
if [ -f "/tmp/ufw" ]; then
	sudo mv -f /tmp/ufw /etc/default/ufw
fi
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


APACHE_ROOT="/var/www"
APP_PATH="$APACHE_ROOT/utn-devops-app"

if [ ! -d "$APACHE_ROOT" ]; then
	sudo mkdir -p $APACHE_ROOT
fi

if [ ! -d "$APP_PATH" ]; then
	cd $APACHE_ROOT
	sudo git clone https://github.com/Fichen/utn-devops-app.git
	cd $APP_PATH
	sudo git checkout unidad-2
fi

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt remove $pkg; done

	sudo su
	# Add Docker's official GPG key:
	sudo apt update -y
	sudo apt install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	#sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /docker.asc
	sudo mv /docker.asc /etc/apt/keyrings/docker.asc
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	# Add the repository to Apt sources:
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
	sudo apt update -y
	#Instalo docker desde el repositorio oficial
	sudo apt -y  install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
	
	#Lo configuro para que inicie en el arranque
	sudo systemctl enable docker
