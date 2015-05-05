# Set the site name
require "json"
vagrant_dir = File.dirname(__FILE__);
config_file = JSON.parse(File.read("#{vagrant_dir}/config.json"))

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "14.04"

    # Setup the dev domain name
    config.vm.network "private_network", ip: "172.31.254.254"
    config.vm.hostname = config_file["hostname"]
    config.hostsupdater.aliases = config_file["aliases"]

    # Setup the server root
    config.vm.synced_folder "./", "/var/www"

    # Don't replace insecure key file - allows for faster SSH
    config.ssh.insert_key = false

    # Provisioning
    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

        # Coobooks
        chef.add_recipe "recipe[apt]" # Update apt-get
        chef.add_recipe "recipe[locale]" # Set locale
        chef.add_recipe "recipe[php-fpm]"
        chef.add_recipe "recipe[composer]"
        chef.add_recipe "recipe[certs]"

        # Site Cookbooks
        chef.add_recipe "recipe[mysql-setup]"
        chef.add_recipe "recipe[nginx::site]"
        chef.add_recipe "recipe[laravel::site]"

        # Recipe settings
        chef.json = {
            "locale" => {
                "lang" => "en_GB.utf8"
            },
            "php-fpm" => {
                "user" => "vagrant",
                "group" => "vagrant"
            },
            "certs" => {
                "dn" => {
                    "country" => "GB",
                    "state" => "Bristol",
                    "city" => "Bristol",
                    "organisation" => "Small Hadron Collider",
                    "department" => nil,
                    "email" => "mark@smallhadroncollider.com"
                }
            },
            "config_file" => config_file
        }
    end

    # Configure VirtualBox
    config.vm.provider :virtualbox do |virtualbox|
        virtualbox.name = config_file["name"]
        virtualbox.memory = 1024
        virtualbox.cpus = 1
        virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
end
