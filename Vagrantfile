Vagrant.configure(2) do |config|

  ## VM settings
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "mev-test"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.vm.synced_folder "jenkins/", "/home/vagrant/jenkins"

  ## Connect Ansible provision
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  # ansible.verbose = "v"
  end

  ## More simplest way to install docker inside guest:
  # config.vm.provision "docker"

end
