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
    'Ubuntu' => $::lsbdistcodename ? {
      'lucid' => 1,
      default => 0
    },
    default => 1
  }

  file { $cert_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    recurse => true,
    purge   => true,
  }

  file { $policies_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    recurse => true,
    purge   => true,
  }

  case $::operatingsystem {

    /Debian|Ubuntu/: {

      package { "libstomp-ruby":
        ensure => absent,
      }
      package { "ruby-stomp":
        ensure  => present,
        require => Package["libstomp-ruby"],
        notify  => Service["mcollective"],
      }

      package { "mcollective":
        ensure  => present,
        require => [Package["rubygems"], Package["ruby-stomp"]],
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
    ensure  => present,
    owner    => 'root',
    group    => 'root',
    mode     => '0400',
    loglevel => debug,  # this is needed to avoid it being logged and reported on every run
    # avoid including highly-dynamic facts as they will cause unnecessary template writes
    content  => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime|timestamp|free)/ }.to_yaml %>'),
    require  => Package['mcollective'],
  }
}
