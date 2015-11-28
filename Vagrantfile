# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, guest: 5000, host: 5000

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

 config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vvvv"
    ansible.playbook = "ansible/playbook.yml"
    ansible.sudo = true
  end

end
