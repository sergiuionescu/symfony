#
# Cookbook Name:: symfony
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

#Cover the provisioning dependency for ruby-dev
package "ruby-dev" do
  action :install
end

include_recipe 'lamp'
include_recipe 'php::module_gd'
include_recipe 'cron'
include_recipe "composer"

package "php5-json" do
  action :install
end

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

project_root = "#{node['symfony']['project']['path']}/#{node['symfony']['project']['name']}"

execute "create-project-#{node['symfony']['project']['name']}" do
  cwd  node['symfony']['project']['path']
  command "symfony new #{node['symfony']['project']['name']} #{node['symfony']['core']['version']}"
  not_if "ls #{project_root}"
end

template "#{project_root}/app/config/parameters.yml" do
  source "parameters.yml.erb"
  variables(
      :database_driver => node['symfony']['project']['database_driver'],
      :database_host => node['symfony']['project']['database_host'],
      :database_name => node['symfony']['project']['database_name'],
      :database_port => node['symfony']['project']['database_port'],
      :database_user => node['symfony']['project']['database_user'],
      :database_password => node['symfony']['project']['database_password'],
      :mailer_transport => node['symfony']['project']['mailer_transport'],
      :mailer_host => node['symfony']['project']['mailer_host'],
      :mailer_user => node['symfony']['project']['mailer_user'],
      :mailer_user => node['symfony']['project']['mailer_password'],
      :locale => node['symfony']['project']['locale'],
      :secret => node['symfony']['project']['secret']
  )
end

execute "symfony-#{node['symfony']['project']['name']}-permissions" do
  command "chown #{node['apache']['user']}:#{node['apache']['group']} -R #{project_root}"
end

execute "setup-db-#{node['symfony']['project']['name']}" do
  cwd  project_root
  command "php app/console doctrine:database:create"
  not_if "ls .install"
end

execute "setup-db-#{node['symfony']['project']['name']}" do
  cwd  project_root
  command "touch .install"
end

web_app "symfony-#{node['symfony']['project']['name']}" do
  template "symfony.conf.erb"
  docroot "#{project_root}/web"
  server_name node['fqdn']
  server_aliases node['symfony']['project']['aliases']
end