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
  config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 4400, host: 4400, auto_correct: true
  config.vm.box_download_insecure = true
  config.vm.hostname = "utn-devops.localhost"
  config.vm.boot_timeout = 3600

  config.vm.provider "virtualbox" do |vb|
    vb.name = "devops-vagrant-ubuntu"
    vb.memory = "4096"
  end

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "file", source: "ufw", destination: "/tmp/ufw"
  config.vm.provision :shell, path: "Vagrant.bootstrap.sh", run: "always"

end
