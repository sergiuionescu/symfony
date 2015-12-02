#
# Cookbook Name:: symfony
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

use_inline_resources

def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Create #{ @new_resource }") do
      create_app
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by("Delete #{ @new_resource }") do
      delete_app
    end
  else
    Chef::Log.info "#{ @current_resource } not found - nothing to do."
  end
end

def load_current_resource
  @current_resource = Chef::Resource::SymfonyApp.new(@new_resource)

  @current_resource.name(@new_resource.name)
  @current_resource.app_name(@new_resource.app_name)
  @current_resource.database_driver(@new_resource.database_driver)
  @current_resource.unix_socket(@new_resource.unix_socket)
  @current_resource.database_host(@new_resource.database_host)
  @current_resource.database_name(@new_resource.database_name)
  @current_resource.database_port(@new_resource.database_port)
  @current_resource.app_root = "/var/www/#{@new_resource.name}"
  @current_resource.database_user(@new_resource.database_user)
  @current_resource.database_password(@new_resource.database_password)
  @current_resource.mailer_transport(@new_resource.mailer_transport)
  @current_resource.mailer_host(@new_resource.mailer_host)
  @current_resource.mailer_user(@new_resource.mailer_user)
  @current_resource.mailer_password(@new_resource.mailer_password)
  @current_resource.locale(@new_resource.locale)
  @current_resource.secret(@new_resource.secret)

  if application_installed?(@current_resource.app_root)
    @current_resource.exists = true
  end
end

def application_installed?(path)
  Dir.exist?(path)
end

def create_app
  execute "create-project-#{current_resource.app_name}" do
    cwd  '/var/www'
    command "symfony new #{current_resource.app_name} #{node['symfony']['core']['version']}"
  end

  template "#{current_resource.app_root}/app/config/parameters.yml" do
    source "parameters.yml.erb"
    variables(
        :database_driver => current_resource.database_driver,
        :unix_socket => current_resource.unix_socket,
        :database_host => current_resource.database_host,
        :database_name => current_resource.database_name,
        :database_port => current_resource.database_port,
        :database_user => current_resource.database_user,
        :database_password => current_resource.database_password,
        :mailer_transport => current_resource.mailer_transport,
        :mailer_host => current_resource.mailer_host,
        :mailer_user => current_resource.mailer_user,
        :mailer_password => current_resource.mailer_password,
        :locale => current_resource.locale,
        :secret => current_resource.secret
    )
  end

  execute "symfony-#{current_resource.app_name}-permissions" do
    command "chown #{node['apache']['user']}:#{node['apache']['group']} -R #{current_resource.app_root}"
  end

  execute "setup-db-#{current_resource.app_name}" do
    @app_console = get_console
    cwd current_resource.app_root
    command "php app/console doctrine:database:create"
    not_if "ls .install"
  end

  execute "setup-db-#{current_resource.app_name}" do
    cwd  current_resource.app_root
    command "touch .install"
  end
end

def delete_app
  execute "symfony-delete-#{current_resource.app_name}" do
    command "rm -rf #{current_resource.app_root}"
  end
end

def get_console
    @app_console = 'app/console'
    if ::File.exist?('/var/www/#{current_resource.app_root}/bin/console')
     @app_console = 'bin/console'
    end
    return @app_console
end;