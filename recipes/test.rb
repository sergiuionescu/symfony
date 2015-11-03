#
# Cookbook Name:: symfony
# Recipe:: test
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

# Start symfony install
symfony_app "symfony" do
  action :create
end
web_app "symfony" do
  template "symfony.conf.erb"
  docroot "#{project_root}/web"
  server_name node['fqdn']
  server_aliases []
end
# End symfony install
