["git", "php5-curl", "php5-json", "php5-mcrypt"].each do |package|
    package "#{package}" do
        action :install
    end
end

execute "php5enmod mcrypt" do
    not_if "php5-fpm -i | grep mcrypt"
    notifies :restart, "service[php-fpm]", :delayed
end
