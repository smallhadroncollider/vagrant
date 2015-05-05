package "nginx" do
    action :install
end

service "nginx" do
  supports :restart => true, :reload => true
  action :enable
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  variables({
     "user" => "vagrant vagrant",
  })
  action :create
end

