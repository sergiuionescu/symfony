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

package "php5-json" do
  action :install
end
