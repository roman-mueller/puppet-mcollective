# Class: mcollective::node
#
# This class provides a simple way to deploy an MCollective node.
# It will install and configure the necessary packages.
#
# This module supports generic STOMP and RabbitMQ connectors,
# with optional SSL support.
#
# It supports PSK and SSL as authentication methods.
#
# Parameters:
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
#
# Actions:
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
  $broker_host,
  $broker_port,
  $security_provider,
  $broker_vhost = '/mcollective',
  $broker_user = 'guest',
  $broker_password = 'guest',
  $broker_ssl = true,
  $broker_ssl_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $broker_ssl_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  $broker_ssl_ca = '/var/lib/puppet/ssl/certs/ca.pem',
  $security_secret = '',
  $security_ssl_private = '/etc/mcollective/ssl/server-private.pem',
  $security_ssl_public = '/etc/mcollective/ssl/server-public.pem',
  $connector = 'rabbitmq',
  $puppetca_cadir = '/srv/puppetca/ca/',
  $rpcauthorization = false,
  $rpcauthprovider = 'action_policy',
  $rpcauth_allow_unconfigured = 0,
  $rpcauth_enable_default = 1,
  $cert_dir = '/etc/mcollective/ssl/clients',
  $policies_dir = '/etc/mcollective/policies',
) {

  include ruby::gems

  # Recent Upstart requires daemonize to be set to 0
  # warning: do not name this variable $daemonize!
  $mcollective_daemonize = $::operatingsystem ? {
    default => 1
  }

  file { [$cert_dir, $policies_dir]:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    recurse => true,
    purge   => true,
    require => Package['mcollective'],
  }

  case $::operatingsystem {

    /Debian|Ubuntu/: {

      package { 'libstomp-ruby':
        ensure => absent,
      }
      package { 'ruby-stomp':
        ensure  => present,
        require => Package['libstomp-ruby'],
        notify  => Service['mcollective'],
      }

      package { 'mcollective':
        ensure  => present,
        require => [Package['rubygems'], Package['ruby-stomp']],
      }

      augeas { 'Enable mcollective':
        lens    => 'Shellvars.lns',
        incl    => '/etc/default/mcollective',
        changes => 'set RUN yes',
        require => Package['mcollective'],
        notify  => Service['mcollective'],
      }

      $mcollective_libdir = '/usr/share/mcollective/plugins'
    }

    /RedHat|CentOS/: {
      package { ['rubygem-net-ping', 'rubygem-stomp']:
        ensure => present,
        notify => Service['mcollective'],
      }

      package { "mcollective":
        ensure  => present,
        require => [Package['rubygem-stomp'], Package['rubygem-net-ping']],
      }

      $mcollective_libdir = '/usr/libexec/mcollective'
    }

    default: {
      fail("Unsupported operating system: ${::operatingsystem}")
    }

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
    owner    => 'root',
    group    => 'root',
    mode     => '0400',
    loglevel => debug,  # this is needed to avoid it being logged and reported
                        # on every run
                        # avoid including highly-dynamic facts as they will
                        # cause unnecessary template writes
    content  => inline_template('<%= scope.to_hash.reject { |k,v|
    k.to_s =~ /(uptime|timestamp|free)/ }.to_yaml %>'),
    require  => Package['mcollective'],
  }
}
