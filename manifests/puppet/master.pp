# == Class openstac_extras::puppet::master
#
# this class configures a machine
# as a puppetmaster.
#
# [*puppetlabs_repo*]
#   (optional) Sets the apt/yum repository from which
#   puppet master will be installed to be puppetlabs
#   Defaults to true
#
# [*puppet_master_address*]
#   (optional) the fqdn of the puppet master
#   Defaults to $::fqdn
#
class openstack_extras::puppet::master (
  $puppetlabs_repo = true,
  $puppet_master_address = $::fqdn,
  $puppetdb_password     = 'datapass',
) {

  $puppet_master_bind_address = $puppet_master_address
  # installs puppet
  # I think I want to assume a puppet 3.x install

  # if this is not set, make sure nodes are all pointing at an apt/yum repo
  # that has puppet > 3.2
  if $puppetlabs_repo {
    include puppet::repo::puppetlabs
  }

  include apache

  # install puppet master
  class { '::puppet::master':
    certname    => $::fqdn,
    autosign    => true,
    modulepath  => '/etc/puppet/modules:/usr/share/puppet/modules',
  }

  # install puppetdb and postgresql
  class { 'puppetdb':
    listen_address      => $puppet_master_bind_address,
    ssl_listen_address  => $puppet_master_bind_address,
    database_password   => $puppetdb_password,
    listen_port         => 8080,
    ssl_listen_port     => 8081
  }

  # Configure the puppet master to use puppetdb.
  class { 'puppetdb::master::config':
    puppetdb_server     => $puppet_master_bind_address,
    puppetdb_port       => 8081,
    restart_puppet      => false,
    strict_validation   => false,
  }
}
