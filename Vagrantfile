# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 4567, host: 4567

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision "shell", privileged: false,  inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y git
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm install 1.9.3
    gem install bundler
    sudo apt-get install -y libcurl4-gnutls-dev
    sudo apt-get install -y libxml2-dev
    sudo apt-get install -y libxslt-dev
  SHELL
end
