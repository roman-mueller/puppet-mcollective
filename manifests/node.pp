# == Class: mcollective::node
#
# This class provides a simple way to deploy an MCollective node.
# It will install and configure the necessary packages.
#
# This module supports generic STOMP and RabbitMQ connectors,
# with optional SSL support.
#
# It supports PSK and SSL as authentication methods.
#
# === Parameters
#
#   ['broker_host']       - The middleware broker host to use.
#   ['broker_port']       - The middleware broker port to use.
#   ['broker_vhost']      - The middleware broker vhost to use.
#                           Currently only used with RabbitMQ.
#   ['broker_user']       - The middleware broker user to use.
#                           If set to false, the user entry will be
#                           ommited from the configuration file
#                           (useful if you want to force using
#                           environment variables instead).
#   ['broker_password']   - The middleware broker password to use.
#   ['broker_ssl']        - Whether to use stomp over SSL
#   ['broker_ssl_cert']   - If using SSL, the path to the SSL public key.
#                           Defaults to Puppet's public certicate.
#   ['broker_ssl_key']    - If using SSL, the path to the SSL private key.
#                           Defaults to Puppet's private certicate.
#   ['broker_ssl_ca']     - If using SSL, the path to the SSL CA certificate.
#                           Defaults to Puppet's CA certificate.
#   ['security_provider'] - The security provider to use.
#                           Currently supported are 'psk' and 'ssl'.
#   ['security_secret']   - If PSK is used, the value of the shared password.
#   ['security_ssl_private'] - If SSL is used, the path to the SSL
#                              private key (shared).
#   ['security_ssl_public']  - If SSL is used, the path to the SSL
#                              public key (shared).
#   ['connector']         - The connector to use. Either 'stomp' or 'rabbitmq'.
#                           Defaults to 'rabbitmq'.
#   ['puppetca_cadir']    - Path to the Puppet CA directory.
#   ['rpcauthorization']  - Whether to use RPC authorization.
#                           False by default.
#   ['rpcauthprovider']   - The RPC authorization plugin to use.
#                           Defaults to 'action_policy'.
#   ['rpcauth_allow_unconfigured'] - Whether to allow unconfigured agents
#                                    with RPC auth. Values are '0' or '1'.
#                                    Defaults to '0'.
#   ['rpcauth_enable_default']     - Whether to enable RPC authorization
#                                    by default. Values are '0' or '1'.
#                                    Defaults to '1'.
#   ['cert_dir']          - Path to the client certificates directory.
#                           Defaults to '/etc/mcollective/ssl/clients'.
#   ['policies_dir']      - Path to the policies directory.
#                           Defaults to '/etc/mcollective/policies'.
#   ['direct_addressing'] - Enable direct addressing.
#                           Defaults to '0'.
#
# === Actions
#
# - Deploys an MCollective node
#
# Sample Usage:
#   class { '::mcollective::node':
#     broker_host       => 'rabbitmq.example.com',
#     broker_port       => '61614',
#     security_provider => 'psk',
#     security_secret   => 'P@S5w0rD',
#   }
#
#   class { '::mcollective::node':
#     broker_host                 => 'rabbitmq.example.com',
#     broker_port                 => '61614',
#     security_provider           => 'ssl',
#   }
#
class mcollective::node (
  $broker_host = $mcollective::broker_host,
  $broker_port = $mcollective::broker_port,
  $security_provider = $mcollective::security_provider,
  $broker_vhost = $mcollective::broker_vhost,
  $broker_user = $mcollective::broker_user,
  $broker_password = $mcollective::broker_password,
  $broker_ssl = $mcollective::broker_ssl,
  $broker_ssl_cert = $mcollective::broker_ssl_cert,
  $broker_ssl_key = $mcollective::broker_ssl_key,
  $broker_ssl_ca = $mcollective::broker_ssl_ca,
  $security_secret = $mcollective::security_secret,
  $security_ssl_private = $mcollective::security_ssl_server_private,
  $security_ssl_public = $mcollective::security_ssl_server_public,
  $connector = $mcollective::connector,
  $puppetca_cadir = $mcollective::puppetca_cadir,
  $rpcauthorization = $mcollective::rpcauthorization,
  $rpcauthprovider = $mcollective::rpcauthprovider,
  $rpcauth_allow_unconfigured = $mcollective::rpcauth_allow_unconfigured,
  $rpcauth_enable_default = $mcollective::rpcauth_enable_default,
  $cert_dir = $mcollective::cert_dir,
  $policies_dir = $mcollective::policies_dir,
  $direct_addressing = $mcollective::direct_addressing,
) {

  if !defined(Class['::mcollective']) {
    fail ('You must declare the mcollective class before the mcollective::node class')
  }

  include ::mcollective::params
  include ::ruby::gems

  $mcollective_daemonize = 1

  validate_absolute_path($cert_dir)
  validate_absolute_path($policies_dir)

  file { [$cert_dir, $policies_dir]:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    recurse => true,
    purge   => true,
    require => Package['mcollective'],
  }

  $mcollective_libdir = $mcollective::params::libdir
  validate_absolute_path($mcollective_libdir)

  case $::osfamily {

    'Debian': {

      package { 'libstomp-ruby':
        ensure => absent,
      }
      package { 'ruby-stomp':
        ensure  => present,
        require => Package['libstomp-ruby'],
        notify  => Service['mcollective'],
      }

      augeas { 'Enable mcollective':
        lens    => 'Shellvars.lns',
        incl    => '/etc/default/mcollective',
        changes => 'set RUN yes',
        require => Package['mcollective'],
        notify  => Service['mcollective'],
      }

    }

    'RedHat': {
      package { ['rubygem-net-ping', 'rubygem-stomp']:
        ensure => present,
        notify => Service['mcollective'],
      }

    }

    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }

  }

  package { 'mcollective':
    ensure  => present,
    require => $mcollective::params::server_require,
  }

  service { 'mcollective':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['mcollective'],
  }

  exec { 'reload mcollective':
    command     => 'pkill -USR1 -f "ruby.*mcollectived"',
    refreshonly => true,
  }

  file { '/etc/mcollective/server.cfg':
    ensure  => present,
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/server.cfg.erb'),
    notify  => Service['mcollective'],
    require => Package['mcollective'],
  }

  file { '/etc/mcollective/facts.yaml':
    ensure   => present,
    backup   => false,
    owner    => 'root',
    group    => 'root',
    mode     => '0400',
    loglevel => debug,  # this is needed to avoid it being logged and reported
                        # on every run
                        # avoid including highly-dynamic facts as they will
                        # cause unnecessary template writes
    content  => template('mcollective/facts.yaml.erb'),
    require  => Package['mcollective'],
  }
}
