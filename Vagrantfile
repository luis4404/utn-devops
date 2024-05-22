# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  box = "ubuntu/mantic64"

  if Vagrant::Util::Platform.darwin? 
    box = "bento/ubuntu-22.04-arm64"
  else
    config.vm.provision "shell", inline: "sudo apt update && sudo apt install -y virtualbox-guest-x11"
  end

  config.vm.box = box
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.box_download_insecure = true
  config.vm.hostname = "utn-devops.localhost"
  config.vm.boot_timeout = 1000

  config.vm.provider "virtualbox" do |vb|
    vb.name = "devops-vagrant-ubuntu"
    vb.memory = "4096"
  end

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "file", source: "utn-dev.conf", destination: "/tmp/utn-dev.conf"
  config.vm.provision :shell, path: "Vagrant.bootstrap.sh", run: "always"
  config.vm.provision :shell, path: "create-user.sh"

end
