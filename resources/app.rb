#
# Cookbook Name:: symfony
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

actions :create, :delete
default_action :create

attribute :app_name, :kind_of => String, :name_attribute => true
attribute :database_host, :kind_of => String, :regex => Resolv::IPv4::Regex, :default => node['symfony']['project']['database_host']
attribute :database_driver, :kind_of => String, :default => node['symfony']['project']['database_driver']
attribute :unix_socket, :kind_of => String, :default => node['symfony']['project']['unix_socket']
attribute :database_name, :kind_of => String, :default => node['symfony']['project']['database_host']
attribute :database_port, :kind_of => String, :default => node['symfony']['project']['database_port']
attribute :database_user, :kind_of => String, :default => node['symfony']['project']['database_user']
attribute :database_password, :kind_of => String, :default => node['symfony']['project']['database_password']
attribute :mailer_transport, :kind_of => String, :default => node['symfony']['project']['mailer_transport']
attribute :mailer_host, :kind_of => String, :default => node['symfony']['project']['mailer_host']
attribute :mailer_user, :kind_of => String, :default => node['symfony']['project']['mailer_user']
attribute :mailer_password, :kind_of => String, :default => node['symfony']['project']['mailer_password']
attribute :locale, :kind_of => String, :default => node['symfony']['project']['locale']
attribute :secret, :kind_of => String, :default => node['symfony']['project']['secret']

attr_accessor :app_root
attr_accessor :exists