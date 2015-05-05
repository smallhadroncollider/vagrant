include_recipe "nginx"

hostname = node["config_file"]["hostname"]
aliases = node["config_file"]["aliases"].join(" ")

certs_certificate hostname do
    action :create
    key "/etc/nginx/ssl/#{hostname}.key"
    certificate "/etc/nginx/ssl/#{hostname}.crt"
end

template "/etc/nginx/sites-available/default" do
    source "nginx.erb"
    variables({
        "default_server" => true,
        "ssl_only" => false,
        "root" => "/var/www/public",
        "server_name" => "#{hostname} #{aliases}",
        "key_file" => "#{hostname}.key",
        "crt_file" => "#{hostname}.crt"
    })
    action :create
    notifies :restart, "service[nginx]", :delayed
end
