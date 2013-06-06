# == Class: mcollective::node::directories
#
# Manages the basic directories for MCollective
class mcollective::directories {
  file { ['/etc/mcollective', '/etc/mcollective/ssl']:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
