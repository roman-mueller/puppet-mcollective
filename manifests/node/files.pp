# == Class: mcollective::node::files
#
# Configures an MCollective node
class mcollective::node::files {
  $cert_dir = $mcollective::node::cert_dir
  $policies_dir = $mcollective::node::policies_dir

  validate_absolute_path($cert_dir)
  validate_absolute_path($policies_dir)

  file { [$cert_dir, $policies_dir]:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    recurse => true,
    purge   => true,
  }

  # Variables for the templates
  $libdir = $mcollective::params::libdir
  validate_absolute_path($libdir)
  $daemonize = 1

  $security_provider = $mcollective::node::security_provider
  validate_string($security_provider)
  $ssl_source_dir = $mcollective::node::ssl_source_dir
  validate_string($ssl_source_dir)

  if $security_provider == 'ssl' and $ssl_source_dir {
    $security_ssl_private = $mcollective::node::security_ssl_private
    validate_absolute_path($security_ssl_private)
    $security_ssl_public = $mcollective::node::security_ssl_public
    validate_absolute_path($security_ssl_public)

    file {
      $security_ssl_private:
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0600',
        source => "${ssl_source_dir}/mco-server.key";

      $security_ssl_public:
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => "${ssl_source_dir}/mco-server.crt";
    }
  }

  file { '/etc/mcollective/server.cfg':
    ensure  => present,
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/server.cfg.erb'),
  }

  # action policy plugin, while it's not packaged yet
  file { "${libdir}/mcollective/util":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  file { "${libdir}/mcollective/util/actionpolicy.rb":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/actionpolicy.rb",
  }
}
