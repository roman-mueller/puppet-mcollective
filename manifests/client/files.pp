# == Class: mcollective::client::files
#
# Configures an MCollective client
class mcollective::client::files {
  include ::mcollective::params

  # For the templates
  $libdir = $mcollective::params::libdir
  $cfgdir = $mcollective::params::cfgdir
  validate_absolute_path($libdir)
  validate_absolute_path($cfgdir)

  $security_provider = $mcollective::client::security_provider
  validate_string($security_provider)
  $ssl_source_dir = $mcollective::client::ssl_source_dir
  validate_string($ssl_source_dir)

  if $security_provider == 'ssl' {

    $broker_ssl_key = $mcollective::client::broker_ssl_key
    validate_absolute_path($broker_ssl_key)
    $key_source = $ssl_source_dir ? {
      undef   => "/var/lib/puppet/ssl/private_keys/${::clientcert}.pem",
      default => "${ssl_source_dir}/mco-client.key",
    }

    $broker_ssl_cert = $mcollective::client::broker_ssl_cert
    validate_absolute_path($broker_ssl_cert)
    $cert_source = $ssl_source_dir ? {
      undef   => "/var/lib/puppet/ssl/certs/${::clientcert}.pem",
      default => "${ssl_source_dir}/mco-client.crt",
    }

    $broker_ssl_ca = $mcollective::client::broker_ssl_ca
    validate_absolute_path($broker_ssl_ca)

    file {
      $broker_ssl_key:
        source => $key_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0644';

      $broker_ssl_cert:
        source => $cert_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0644';

      $broker_ssl_ca:
        source => '/var/lib/puppet/ssl/certs/ca.pem',
        owner  => 'root',
        group  => 'root',
        mode   => '0644';
    }

    $broker_user = $mcollective::client::broker_user
    file { '/etc/profile.d/mco-client.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => inline_template(
'if [ $(id -nu) != "root" ]; then
<%- unless @broker_user or @broker_user.nil? -%>
  export STOMP_USER="$USER"
<%- end -%>
  export MCOLLECTIVE_SSL_PRIVATE="$HOME/.mc/$USER-private.pem"
  export MCOLLECTIVE_SSL_PUBLIC="$HOME/.mc/$USER.pem"
fi
'),
    }
  }

  concat { "${cfgdir}/client.cfg":
    mode  => '0644',
    owner => 'root',
    group => 'root',
  }

  concat::fragment { 'mcollective client.cfg base':
    ensure  => present,
    order   => '00',
    target  => "${cfgdir}/client.cfg",
    content => template('mcollective/client.cfg.erb'),
  }

  $module_path = get_module_path($module_name)
  file { '/etc/bash_completion.d/mco':
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => file("${module_path}/files/bash_completion.sh"),
  }
}
