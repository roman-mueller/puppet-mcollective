# == Class: mcollective::node::files
#
# Configures an MCollective node
class mcollective::node::files {
  $mcollective_daemonize = 1

  $cert_dir = $mcollective::node::cert_dir
  $policies_dir = $mcollective::node::policies_dir

  validate_absolute_path($cert_dir)
  validate_absolute_path($policies_dir)

  # For the templates
  $libdir = $mcollective::params::libdir
  validate_absolute_path($libdir)

  file { [$cert_dir, $policies_dir]:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    recurse => true,
    purge   => true,
  }

  file { '/etc/mcollective/server.cfg':
    ensure  => present,
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/server.cfg.erb'),
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
  }

  $security_provider = $mcollective::node::security_provider
  validate_string($security_provider)
  $ssl_source_dir = $mcollective::node::ssl_source_dir
  validate_string($ssl_source_dir)

  if $security_provider == 'ssl' and $ssl_source_dir {
    $ssl_server_private = $mcollective::node::security_ssl_private
    validate_absolute_path($ssl_server_private)
    $ssl_server_public = $mcollective::node::security_ssl_public
    validate_absolute_path($ssl_server_public)

    file {
      $ssl_server_private:
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0600',
        source => "${ssl_source_dir}/mco-server.key";

      $ssl_server_public:
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => "${ssl_source_dir}/mco-server.crt";
    }
  }
}
