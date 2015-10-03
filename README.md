symfony
=======

Symfony environment with Berkshelf Chef and Vagrant support
* Master: [![Build Status](https://api.travis-ci.org/sergiuionescu/symfony.svg?branch=master)](http://travis-ci.org/sergiuionescu/symfony)
* Dev: [![Build Status](https://api.travis-ci.org/sergiuionescu/symfony.svg?branch=dev)](http://travis-ci.org/sergiuionescu/symfony)


Requirements
------------
* chef-dk: 0.3.0
* chef-solo: tested on 11.8.2
* berkshelf: tested on 3.1.5

Extra development requirements
-----------------------------
* vagrant >= 1.5.2
* chef dk >= 0.2.0
* virtualbox: tested on 4.1.14
* vagrant-berkshelf (vagrant plugin install vagrant-berkshelf) - Optional, kitchen converge can be used to launch the vm instead of vagrant up

* Note: there is currently an issue with running provision a second time with vagrant-berkshelf 4.0.0. See https://github.com/berkshelf/vagrant-berkshelf/issues/237

Resources links
---------------
* Chef DK(includes Berkshelf): https://downloads.getchef.com/chef-dk/
* Vagrant: https://www.vagrantup.com/downloads.html
* Virtualbox: https://www.virtualbox.org/wiki/Downloads


How to test dev environment
---------------------------
- Clone the repository
- Go to the project root
- Run "kitchen converge default-ubuntu-1404" (or "vagrant up" if you wish to use vagrant-berkshelf)

Customizing your dev environment
--------------------------------
The role used to provision the dev environment, you can create your own role to fit your needs:
```json
{
    "name": "symfony",
    "chef_type": "role",
    "json_class": "Chef::Role",
    "description": "Symfony environment configuration.",
    "run_list": [
        "recipe[symfony]",
        "recipe[lamp::nfs]",
        "recipe[lamp::xdebug]"
    ],
    "default_attributes": {
        "lamp": {
            "xdebug": {
                "directives": {
                    "remote_host": "10.0.2.2",
                    "remote_enable": 0,
                    "remote_autostart": 1
                }
            }
        }
    }
}
```

Details:
```json
"run_list": [
        "recipe[symfony]",
        "recipe[lamp::nfs]",
        "recipe[lamp::xdebug]"
    ],
```
The recipes lamp::nfs and lamp::xdebug are only required for the dev environment to expose a nfs share of your /var/www directory and install the xdebug extension for php.


```json
"mysql": {
    "server_root_password": "",
    "server_repl_password": "",
    "server_debian_password": ""
}
```
Configure your mysql dev server credentials.

```json
"lamp": {
    "xdebug": {
        "directives": {
            "remote_host": "10.0.2.2",
            "remote_enable": 0,
            "remote_autostart": 1
        }
    }
}
```
Set the xdebug configuration, all xdebug configuration directives are supported here. In this example xdebug is connecting back on the vm's NAT interface, 
configured to start the debugging session automatically but disabled. You need to enable it manually by editing your xdebug.ini.

Customizing the role in production
----------------------------------

An example role for production would be the following:
```json
{
    "name": "Symfony",
    "chef_type": "role",
    "json_class": "Chef::Role",
    "description": "Symfony environment configuration.",
    "run_list": [
        "recipe[symfony]"
    ],
    "default_attributes": {
        "mysql": {
            "server_root_password": "supersecretpassword",
            "server_repl_password": "supersecretpassword",
            "server_debian_password": "supersecretpassword"
        }
    }
}
```
Notice that you can drop the dependencies on nfs and xdebug, you should also set a more secure password for your mysql server.

Source mounts
-------------

The project root directory is mounted inside the dev virtual machine directory under the /vagrant path when using both kitchen converge or vagrant up to launch the machine.

Todos
-----
- Expose an interface for creating source symlinks
