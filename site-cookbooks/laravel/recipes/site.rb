include_recipe "laravel"

db = node["config_file"]["db"] 

template "/var/www/.env" do
  source ".env.erb"
  variables({
      "key" => (1..30).map { ('a'..'z').to_a[rand(26)] }.join,
      "db_name" => db["name"],
      "db_user" => db["user"],
      "db_pass" => db["pass"],
      "hostname" => node["config_file"]["hostname"]
  })
  action :create
end

execute "composer install" do
    cwd "/var/www"
end

execute "php artisan migrate" do
    cwd "/var/www"
end

execute "php artisan db:seed" do
    cwd "/var/www"
end
