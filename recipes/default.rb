#
# Cookbook Name:: symfony
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe 'lamp'

remote_file "#{Chef::Config[:file_cache_path]}/symfony.phar" do
  source "http://symfony.com/installer"
end

execute "install-symfony-cli" do
  cwd Chef::Config[:file_cache_path]
  command "sudo mv symfony.phar /usr/local/bin/symfony"
  not_if "ls /usr/local/bin/symfony"
end

execute "permissions-symfony-cli" do
  cwd "/tmp"
  command "chmod a+x /usr/local/bin/symfony"
end

