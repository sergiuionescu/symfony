default['symfony']['core']['version'] = 'latest'

default['symfony']['project']['name'] = 'my_project'
default['symfony']['project']['path'] = '/var/www'
default['symfony']['project']['aliases'] = ['my_project.local']

default['symfony']['project']['database_driver'] = 'pdo_mysql'
default['symfony']['project']['unix_socket'] = '/var/run/mysql-default/mysqld.sock'
default['symfony']['project']['database_host'] = '127.0.0.1'
default['symfony']['project']['database_name'] = 'my_project'
default['symfony']['project']['database_port'] = 'null'
default['symfony']['project']['database_user'] = 'root'
default['symfony']['project']['database_password'] = 'root'
default['symfony']['project']['mailer_transport'] = 'smtp'
default['symfony']['project']['mailer_host'] = '127.0.0.1'
default['symfony']['project']['mailer_user'] = 'null'
default['symfony']['project']['mailer_password'] = 'null'
default['symfony']['project']['locale'] = 'en'
default['symfony']['project']['secret'] = 'ThisTokenIsNotSoSecretChangeIt'