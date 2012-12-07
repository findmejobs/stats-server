#
# Cookbook Name:: fireandforget
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
npm_package "coffee-script" do
  action :install
end

npm_package "fire-and-forget" do
  action :install
end

directory "/usr/share/fireandforget/scripts" do
  owner "root"
  mode "0755"
  action :create
  recursive true
end

user "fireandforget" do
  comment "fireandforget"
  system true
  shell "/bin/false"
end

service "fireandforget" do
  provider Chef::Provider::Service::Upstart

  restart_command "stop fireandforget; start fireandforget"
  start_command "start fireandforget"
  stop_command "stop fireandforget"

  supports :restart => true, :start => true, :stop => true
end

directory "/usr/share/fireandforget/scripts" do
  action :create
end

template "/usr/share/fireandforget/scripts/start" do
  source "upstart.start.erb"
  mode 0755

  notifies :restart, resources(:service => "fireandforget")
end

cookbook_file "/etc/init/fireandforget.conf" do
  source "upstart.conf"
  mode 0644

  notifies :restart, resources(:service => "fireandforget")
end

file node[:fireandforget][:log_file] do
  owner "fireandforget"
  group "root"
  action :create_if_missing
end

service "fireandforget" do
  action [ :enable, :start ]
end
