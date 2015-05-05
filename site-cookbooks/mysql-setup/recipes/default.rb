package "php5-mysql" do
    action :install
    notifies :restart, "service[php-fpm]", :delayed
end

mysql2_chef_gem "default" do
    action :install
end

mysql_client "default" do
    action :create
end

mysql_service "default" do
    port "3306"
    bind_address "0.0.0.0"
    initial_root_password "root"
    socket "/var/run/mysqld/mysqld.sock"
    action [:create, :start]
end

connection_info = {
    :host      => "127.0.0.1",
    :username  => "root",
    :password  => "root"
}

db = node["config_file"]["db"]

database db["name"] do
    provider   Chef::Provider::Database::Mysql
    connection connection_info
    action     :create
end

database_user db["user"] do
    provider   Chef::Provider::Database::MysqlUser
    action :create
    password db["pass"]
    connection connection_info
end

database_user db["user"] do
    provider   Chef::Provider::Database::MysqlUser
    action :grant
    host "%"
    password db["pass"]
    database_name db["name"]
    privileges [:all]
    connection connection_info
end
