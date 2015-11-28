Ansible provisioning for Alfred
===============================

In the root directory of this repository you will find a Vagrantfile to privision a development machine. That Vagrantfile uses ansible, so you should start by installing Vagrant and Ansible. After that you should execute the following to commands:

```
# go to {alfred_root_directory/ansible}
export ANSIBLE_ROLES_PATH=roles/ 
ansible-galaxy install -r roles.yml
```

This will download the rvm_role that is use to provision the alfred machine. Once completed this action, you can provision your machine.

```
# go to {alfred_root_directory}
vagrant up
```

This command could take a while the fist time, because it will download the a base box.
Once the vagrant up command finishes, you can enter the machine by executing 

```
vagrant ssh
```

By default the provisioned machine will share alfred directory in your host machine, that is

```
alfred-source@your_host is synced with provisioned_machine/vagrant
```

This allow you to use you favourite IDE to edit the files and use the provisioned machine to run the app.