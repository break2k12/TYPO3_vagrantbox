# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://github.com/kraksoft/vagrant-box-ubuntu/releases/download/14.04/ubuntu-14.04-amd64.box"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
  end
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network "public_network"
  config.vm.synced_folder "html", "/vagrant/html",
  mount_options: ["dmode=775,fmode=775"]
  config.vm.synced_folder "html", "/vagrant/html", id: "vagrant-root" , :owner => "www-data", :group => "www-data"
end
